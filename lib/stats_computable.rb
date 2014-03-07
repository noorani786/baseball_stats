module StatsComputable
  extend self
  
  def compute(stats_opts)
    {
      most_improved_batting_average: compute_most_improved_batting_average(stats_opts[:most_improved_batting_average]),
      slugging_percentages: compute_slugging_percentages(stats_opts[:slugging_percentage]),
      most_improved_fantasy_players: compute_most_improved_fantasy_players(stats_opts[:most_improved_fantasy_players]),
      triple_crown_winners: compute_triple_crown_winners(stats_opts[:triple_crown_winners])
    } 
  end
  
  def compute_most_improved_batting_average(miba_opts)
    stat_package miba_opts, BattingStat.batting_average_improvements(miba_opts)
  end
  
  def compute_slugging_percentages(sp_opts)
    stat_package sp_opts, BattingStat.slugging_percentages(sp_opts)
  end
  
  def compute_most_improved_fantasy_players(fs_opts)
    stat_package fs_opts, BattingStat.fantasy_score_improvements(fs_opts)
  end
  
  def compute_triple_crown_winners(tc_opts)
    stat_package tc_opts, BattingStat.triple_crown_winners(tc_opts)
  end
  
  private
  
  def stat_package(opts, result)
    { opts: opts, result: result }
  end
end