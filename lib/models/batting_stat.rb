# Instances of this class represent batting stat for player/year/team combination.
class BattingStat < ActiveRecord::Base
  
  DEFAULT_OPTS = { start_year: 1901, end_year: 9999, exclude_any_at_bats_below: 0}
  BATTING_AVERAGE_FORMULA = "sum(hits) / (sum(at_bats) * 1.0)"
  TEAM_SLUGGING_PERCENTAGE_FORMULA = "((hits-doubles-triples-home_runs) + (2*doubles) + (3*triples) + (4*home_runs)) / (at_bats*1.0)"
  FANTASY_SCORE_FORMULA = "(4* sum(home_runs)) + sum(runs_batted_in) + sum(stolen_bases) - sum(caught_stealing)"
  
  belongs_to :player
  
  validates :year, presence: true
  validates :team, presence: true
  
  # there can only be one record per player/year/team. you can have a player be part of two team in a year due to trades, etc.
  validates_uniqueness_of :player_id, scope: [:year, :team]
  
  def batting_average
    hits / (at_bats * 1.0)
  end
  
  def fantasy_score
    (4*home_runs) + runs_batted_in + stolen_bases - caught_stealing
  end
  
  # opts => { 
  #   top:          -- indicates the number of top players to return (ex: top 10)
  #   start_year:   -- start year for comparision
  #   end_year:     -- end year for comparision
  #   exclude_any_at_bats_below: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.batting_average_improvements(opts)
    calculate_improvements batting_averages(opts), opts[:top] { |ba| ba.season_batting_average }
  end
  
  # opts => { 
  #   top:        -- indicates the number of top players to return (ex: top 10)
  #   start_year:  -- start year for comparision
  #   end_year:    -- end year for comparision
  #   exclude_any_at_bats_below: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.fantasy_score_improvements(opts)
    calculate_improvements fantasy_scores(opts), opts[:top] { |fs| fs.season_fantasy_score }
  end
  
  # opts => { 
  #   start_year:  -- start year for comparision
  #   end_year:    -- end year for comparision
  #   exclude_any_at_bats_below: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.fantasy_scores(opts)
    opts = DEFAULT_OPTS.merge(opts)
    
    select_common("#{FANTASY_SCORE_FORMULA} as season_fantasy_score").
    group_and_filter_by_year_and_at_bats(opts).
    order(:player_id, :year)
  end
  
  def self.triple_crown_winners(opts)
    opts[:years].map { |y| triple_crown_winner y, opts[:exclude_any_at_bats_below] }
  end
  
  # opts => { 
  #   start_year:  -- start year for comparision
  #   end_year:    -- end year for comparision
  #   exclude_any_at_bats_below: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.batting_averages(opts)
    opts = DEFAULT_OPTS.merge(opts)
    
    select_common("#{BATTING_AVERAGE_FORMULA} as season_batting_average").
    group_and_filter_by_year_and_at_bats(opts).
    order(:player_id, :year)
  end
  
  # opts => { 
  #   team:  -- the team for which to compute percentages
  #   year:  -- the year for which to compute stats  
  # }
  def self.slugging_percentages(opts)
     unless opts[:team] && opts[:team]
      raise ArgumentError.new "must supply { team: <>, year: <> }"
     end 
          
     select_common("team, #{TEAM_SLUGGING_PERCENTAGE_FORMULA} as slugging_percentage").
     where(year: opts[:year]).where(team: opts[:team]).
     order("slugging_percentage DESC")
  end
  
  def self.triple_crown_winner(year, exclude_any_at_bats_below)
    best_ba   = best_batting_average(year, exclude_any_at_bats_below)
    best_hr   = best_home_runs(year, exclude_any_at_bats_below)
    best_rbi  = best_runs_batted_in(year, exclude_any_at_bats_below)
    
    if (best_ba.player_id == best_hr.player_id) && (best_ba.player_id == best_rbi.player_id)
      { 
        year: year,
        player_id: best_ba.player_id, 
        first_name: best_ba.first_name,
        last_name: best_ba.last_name,
        batting_average: best_ba.season_batting_average, 
        home_runs: best_hr.season_home_runs,
        runs_batted_in: best_rbi.season_runs_batted_in
      }
    else 
      nil
    end
  end
  
  def self.best_batting_average(year, exclude_any_at_bats_below)
    query_for_best year, "#{BATTING_AVERAGE_FORMULA} as season_batting_average", "season_batting_average", exclude_any_at_bats_below
  end
  
  def self.best_home_runs(year, exclude_any_at_bats_below)
    query_for_best year, "sum(home_runs) as season_home_runs", "season_home_runs", exclude_any_at_bats_below
  end
  
  def self.best_runs_batted_in(year, exclude_any_at_bats_below)
    query_for_best year, "sum(runs_batted_in) as season_runs_batted_in", "season_runs_batted_in", exclude_any_at_bats_below
  end  
  
  private 
  
  def self.query_for_best(year, select_columns, order_column, exclude_any_at_bats_below)
    select_common(select_columns).
    group_and_filter_by_year_and_at_bats({start_year: year, end_year: year, exclude_any_at_bats_below: exclude_any_at_bats_below}).
    order("#{order_column} DESC").
    first
  end
  
  def self.select_common(addtl_fields)
    select("player_id, first_name, last_name, year, #{addtl_fields}").
    joins(:player)
  end
  
  def self.group_and_filter_by_year_and_at_bats(opts)
    group("player_id, year, first_name, last_name").
    having("sum(at_bats) >= ?", opts[:exclude_any_at_bats_below]).
    where("year = ? OR year = ?", opts[:start_year], opts[:end_year])
  end
  
  # def self.where_year_range_and_at_bats(opts)
  #   where("year = ? OR year = ?", opts[:start_year], opts[:end_year]).
  #   where("at_bats >= ?", opts[:exclude_any_at_bats_below])
  # end
  
  def self.calculate_improvements(stats, limit, &calc)
    improvements = []
    current_calcs = []
    current_stat = nil
    
    #lamda to create improvement
    improvement_lambda = lambda do
      {
        player_id:       current_stat.player_id, 
        first_name:      current_stat.first_name,
        last_name:       current_stat.last_name,
        start_year_calc: current_calcs[0],
        end_year_calc:   current_calcs[1],
        improvement:     current_calcs[1] - current_calcs[0]
      }
    end
    
    stats.each do |s|
      current_stat ||= s
      if current_stat.player_id == s.player_id
        current_calcs << calc.call(s)
        if current_calcs.count == 2
          improvements << improvement_lambda.call()
          current_stat = nil
          current_calcs.clear
        end
      else
        current_stat = nil
        current_calcs.clear
        redo
      end
    end
    
    limit ||= improvements.count
    (improvements.sort! { |x, y|  y[:improvement] <=> x[:improvement] })[0..limit-1]
  end
end