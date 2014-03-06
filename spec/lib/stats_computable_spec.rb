require "spec_helper"

describe StatsComputable do
  describe "compute_most_improved_batting_average" do
    opts = { top: 1, start_year: 2012, end_year: 2013, exclude_any_at_bats_below: 200 }
    
    let!(:player1) { FactoryGirl.create(:player) }
    let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, hits: 200) }
    let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, hits: 300) }
    
    let(:stats) { StatsComputable.compute_most_improved_batting_average opts }
    
    it 'returns hash with opts and result' do  
      expect(stats).to include(:opts)
      expect(stats).to include(:result)
    end
    
    it 'includes player_name, start_year_average, end_year_average, and improvement' do
      ps = stats[:result].first
      expect(ps).to include(:player_name)
      expect(ps).to include(:start_year_average)
      expect(ps).to include(:end_year_average)
      expect(ps).to include(:improvement)
    end
  end
end

# skip writing tests of StatsWritable and StatsRunnable since they can be easily verified 
# by looking at the output files.