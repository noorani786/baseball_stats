module StatsComputable
  extend self
  
  def compute(stats_opts)
    {
      most_improved_batting_average: compute_most_improved_batting_average(stats_opts[:most_improved_batting_average]),
      slugging_percentages: compute_slugging_percentages(stats_opts[:slugging_percentage])
    } 
  end
  
  def compute_most_improved_batting_average(miba_opts)
    player_stats = BattingStat.batting_average_improvements miba_opts
    
    # include_player_name player_stats
    
    { opts: miba_opts, result: player_stats }
  end
  
  def compute_slugging_percentages(sp_opts)
    stats = BattingStat.slugging_percentages sp_opts
    
    # include_player_name stats
    
    { opts: sp_opts, result: stats }
  end
  
  private 
  
  # def include_player_name(stats)
  #   stats.each { |s| s.merge!({ player_name: Player.find(s[:player_id]).full_name }) }
  # end
end