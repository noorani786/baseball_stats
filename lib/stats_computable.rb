module StatsComputable
  extend self
  
  def compute(stats_opts)
    {
      most_improved_batting_average: compute_most_improved_batting_average(stats_opts[:most_improved_batting_average])
    } 
  end
  
  def compute_most_improved_batting_average(miba_opts)
    player_stats = BattingStat.players_by_batting_average_improvements miba_opts
    
    player_stats.each { |ps| ps.merge!({ player_name: Player.find(ps[:player_id]).full_name }) }
    
    { opts: miba_opts, result: player_stats }
  end
end