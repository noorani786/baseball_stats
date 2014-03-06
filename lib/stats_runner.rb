require 'stats_writeable'
require 'stats_computable'

class StatsRunner
  include StatsComputable
  include StatsWriteable
  
  DEFAULT_OPTS = { 
    most_improved_batting_average_opts: { top: 1, start_year: 2009, end_year: 2010, exclude_any_below_at_bats: 200 }, 
    slugging_percentage_opts: { team: 'OAK', year: 2007 },
    most_improved_fantasy_players_opts: { top: 5, from_year: 2011, to_year: 2012, exclude_any_below: 500 },
    triple_crown_winners_opts: { years: [2011, 2012] }
  }
  
  def initialize(opts=DEFAULT_OPTS, output_file=$stdout)
    @stats_opts = opts
    @output_file = output_file
  end
  
  def run
    write(compute(@stats_opts), @output_file)
  end
  
end