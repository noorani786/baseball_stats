module StatsWriteable
  
  def write(stats, file=$stdout)
    write_header(file)
    write_body(stats, file)
    write_footer(file)  
  end
  
  private 
  
  def write_header(file)
    file.write("Batting Stats\n")
    file.write(("-" * 100) + "\n")
  end
  
  def write_footer(file)
    file.write("\nDone printing batting stats. Thank you.\n")
  end
  
  def write_body(stats, file)
    write_miba(stats[:most_improved_batting_average], file)
  end
  
  def write_miba(miba, file)
    opts = miba[:opts]
    player_stats = miba[:result]
    
    file.write("Top #{opts[:top]} most improved batting averages from #{opts[:start_year]} to #{opts[:end_year]}:\n")
    player_stats.each_with_index do |ps, idx|
      file.write("\t#{idx+1}. #{ps[:player_name]}, #{opts[:start_year]} Avg.: #{ps[:start_year_average]}, #{opts[:end_year]} Avg.: #{ps[:end_year_average]}, Improvement: #{ps[:improvement]}\n")
    end
  end
end