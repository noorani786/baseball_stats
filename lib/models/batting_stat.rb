class BattingStat < ActiveRecord::Base
  belongs_to :player
  
  validates :year, presence: true
  validates :team, presence: true
  
  # there can only be one record per player/year combination
  validates_uniqueness_of :player_id, scope: :year
  
  def batting_average
    hits / (at_bats * 1.0) if hits && at_bats
  end
  
  # opts => { 
  #   top:        -- indicates the number of top players to return (ex: top 10)
  #   start_year:  -- start year for comparision
  #   end_year:    -- end year for comparision
  #   exclude_any_at_bats_below: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.batting_average_improvements(opts)
    
    self.calculate_improvements batting_averages(opts), opts[:top] do |ba|
      ba.batting_avg
    end
    
    # ba_improvements = []
    # current_avgs = []
    # current_stat = nil
    
    # #lamda to create player_improvement
    # ba_improvement_lambda = lambda do
    #   {
    #     player_id:          current_stat.player_id, 
    #     first_name:         current_stat.first_name,
    #     last_name:          current_stat.last_name,
    #     start_year_average: current_avgs[0],
    #     end_year_average:   current_avgs[1],
    #     improvement:        current_avgs[1] - current_avgs[0]
    #   }
    # end
    
    # batting_averages(opts).each do |ba|
    #   current_stat ||= ba
    #   if current_stat.player_id == ba.player_id
    #     current_avgs << ba.batting_avg
    #     if current_avgs.count == 2
    #       ba_improvements << ba_improvement_lambda.call()
    #       current_stat = nil
    #       current_avgs.clear
    #     end
    #   else
    #     current_stat = nil
    #     current_avgs.clear
    #     redo
    #   end
    # end
    
    # limit = (opts[:top] || ba_improvements.count) - 1
    # (ba_improvements.sort! { |x, y|  y[:improvement] <=> x[:improvement] })[0..limit]
  end
  
  def self.fantasy_score_improvements(opts)
    
  end
  
  # opts => { 
  #   start_year:  -- start year for comparision
  #   end_year:    -- end year for comparision
  #   exclude_any_at_bats_below: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.batting_averages(opts)
    opts = { start_year: 1901, end_year: 9999, exclude_any_at_bats_below: 0}.merge(opts)
    
    select("player_id, first_name, last_name, year, hits / (at_bats * 1.0) as batting_avg").
    joins(:player).
    where("year = ? OR year = ?", opts[:start_year], opts[:end_year]).
    where("at_bats >= ?", opts[:exclude_any_at_bats_below]).
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
     
     sp_formula = "((hits-doubles-triples-home_runs) + (2*doubles) + (3*triples) + (4*home_runs)) / (at_bats*1.0)"
     
     select("player_id, first_name, last_name, team, year, #{sp_formula} as slugging_percentage").
     joins(:player).
     where(year: opts[:year]).where(team: opts[:team]).
     order("slugging_percentage DESC")
  end
  
  # def self.players_with_at_bats(exclude_any_at_bats_below)
  #   group(:player_id).select(:player_id).having("sum(at_bats) >= ?", exclude_any_at_bats_below)
  # end
  
  private 
  
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