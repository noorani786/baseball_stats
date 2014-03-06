require 'stats_writeable'
require 'stats_computable'
require 'utils'

class StatsRunner
  extend StatsComputable
  extend StatsWriteable
  
  DEFAULT_OPTS = { 
    most_improved_batting_average: { top: 1, start_year: 2009, end_year: 2010, exclude_any_at_bats_below: 200 }, 
    slugging_percentage: { team: 'OAK', year: 2007 },
    most_improved_fantasy_players: { top: 5, start_year: 2011, end_year: 2012, exclude_any_at_bats_below: 500 },
    triple_crown_winners: { years: [2011, 2012] }
  }
  
  def self.run(opts=DEFAULT_OPTS, output_file=$stdout)
    opts = Utils.symbolize_keys(opts)
    write(compute(opts), output_file)
  end
  
end