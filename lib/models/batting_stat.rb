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
  #   exclude_any_below_at_bats: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.players_by_batting_average_improvements(opts)
    player_improvements = []
    current_player_stats = []
    current_player_id = nil
    
    #lamda to create player_improvement
    player_improvement_lambda = lambda do
      {
        player_id: current_player_id, 
        start_year_average: current_player_stats[0],
        end_year_average: current_player_stats[1],
        improvement: current_player_stats[1] - current_player_stats[0]
      }
    end
    
    batting_averages(opts).each do |ba|
      current_player_id ||= ba.player_id
      if current_player_id == ba.player_id
        current_player_stats << ba.batting_avg
        if current_player_stats.count == 2
          player_improvements << player_improvement_lambda.call()
          current_player_id = nil
          current_player_stats.clear
        end
      else
        current_player_id = nil
        current_player_stats.clear
      end
    end
    
    limit = (opts[:top] || player_improvements.count) - 1
    (player_improvements.sort! { |x, y|  y[:improvement] <=> x[:improvement] })[0..limit]
  end
  
  # opts => { 
  #   start_year:  -- start year for comparision
  #   end_year:    -- end year for comparision
  #   exclude_any_below_at_bats: -- exclude any players for whom at_bats is lower than this value for the year. 
  # }
  def self.batting_averages(opts)
    opts = { from_year: 1901, to_year: 9999, exclude_any_below_at_bats: 0}.merge(opts)
    
    select("player_id, year, hits / (at_bats * 1.0) as batting_avg").
    where("year = ? OR year = ?", opts[:start_year], opts[:end_year]).
    where("at_bats >= ?", opts[:exclude_any_below_at_bats]).
    order(:player_id, :year)
  end
  
  # def self.players_with_at_bats(exclude_any_below_at_bats)
  #   group(:player_id).select(:player_id).having("sum(at_bats) >= ?", exclude_any_below_at_bats)
  # end
end