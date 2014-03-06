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
    write_sp(stats[:slugging_percentages], file)
  end
  
  def write_miba(miba, file)
    opts = miba[:opts]
    stats = miba[:result]
    
    file.write("Top #{opts[:top]} most improved batting averages from #{opts[:start_year]} to #{opts[:end_year]}:\n")
    stats.each_with_index do |ps, idx|
      player_name = player_name ps[:first_name], ps[:last_name]
      s_avg       = ps[:start_year_average].round(5)
      e_avg       = ps[:end_year_average].round(5)
      imp         = ps[:improvement].round(5)
      
      file.write("  #{idx+1}.\t#{player_name}\t\t#{opts[:start_year]} Avg.: #{s_avg}\t#{opts[:end_year]} Avg.: #{e_avg}\tImprovement: #{imp}\n")
    end
    file.write("\n")
  end
  
  def write_sp(sp, file)
    opts = sp[:opts]
    stats = sp[:result]
    
    file.write("Slugging percentages for all players on team '#{opts[:team]}' in #{opts[:year]}:\n")
    stats.each_with_index do |s, idx|
      player_name = player_name s.first_name, s.last_name
      sp = s.slugging_percentage ? s.slugging_percentage.round(5) : 0.0
      
      file.write("  #{idx+1}.\t#{player_name}\t\t#{sp}\n")
    end
  end
  
  def player_name(fn, ln)
    "#{fn} #{ln}".truncate(15, omission: '...')
  end
end