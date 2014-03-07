require 'spec_helper'

describe BattingStat do
    
  let(:player1) { FactoryGirl.create(:player) }
  let(:player2) { FactoryGirl.create(:player) }
  let(:player3) { FactoryGirl.create(:player) }
  let(:player4) { FactoryGirl.create(:player) }
  let(:player5) { FactoryGirl.create(:player) }
  
  TOP = 3
  let(:opts) { { top: TOP, start_year: 2012, end_year: 2013, exclude_any_at_bats_below: 200} }
  
  describe "#batting_average_improvements" do
    context "when no player has above 200 at_bats" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 10) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 15) }
      
      let!(:player2_stat_2012)  { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 10) } 
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2013, at_bats: 199) }
      
      it 'returns empty collection' do
        expect(BattingStat.count).to equal(4)
        players = BattingStat.batting_average_improvements(opts)
        expect(players).to be_empty
      end
    end
    
    context 'when no player falls in the year range' do
      let!(:player1_stat_2010) { FactoryGirl.create(:batting_stat, player: player1, year: 2010, at_bats: 500) }
      let!(:player1_stat_2011) { FactoryGirl.create(:batting_stat, player: player1, year: 2011, at_bats: 500) }
      
      let!(:player2_stat_2010)  { FactoryGirl.create(:batting_stat, player: player2, year: 2010, at_bats: 500) } 
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500) }
      
      it 'returns empty collection' do
        expect(BattingStat.count).to equal(4)
        players = BattingStat.batting_average_improvements(opts)
        expect(players).to be_empty
      end
    end
    
    context "when there is just one player that qualifies" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, hits: 200) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, hits: 300) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2011, at_bats: 500, hits: 200) }
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, hits: 300) }
      
      let!(:player3_stat_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, at_bats: 50, hits: 200) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 50, hits: 300) } 
       
      it 'returns that player with correct numbers' do
        players = BattingStat.batting_average_improvements(opts)
        expect(players.count).to eq(1)
        p = players.first
        expect(p[:player_id]).to eq(player1.id)
        expect(p[:start_year_calc]).to eq(player1_stat_2012.batting_average)
        expect(p[:end_year_calc]).to eq(player1_stat_2013.batting_average)
        expect(p[:improvement]).to eq(player1_stat_2013.batting_average - player1_stat_2012.batting_average)
      end
    end
    
    context "when there are multiple players" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, hits: 100) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, hits: 150) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, hits: 100) }
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2013, at_bats: 500, hits: 200) }
      
      let!(:player3_stat_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, at_bats: 500, hits: 100) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 500, hits: 300) }
      
      let!(:player4_stat_2012) { FactoryGirl.create(:batting_stat, player: player4, year: 2012, at_bats: 500, hits: 100) }
      let!(:player4_stat_2013) { FactoryGirl.create(:batting_stat, player: player4, year: 2013, at_bats: 500, hits: 50) }
      
      let!(:player5_stat_2012) { FactoryGirl.create(:batting_stat, player: player5, year: 2012, at_bats: 500, hits: 50) }
      let!(:player5_stat_2013) { FactoryGirl.create(:batting_stat, player: player5, year: 2013, at_bats: 500, hits: 20) }
      
      it "returns top #{TOP} as specified" do
        players = BattingStat.batting_average_improvements opts
        expect(players.count).to eq(3)
        expect(players.first[:player_id]).to eq(player3.id)
        expect(players[1][:player_id]).to eq(player2.id)
        expect(players.last[:player_id]).to eq(player1.id)
      end
    end
    
    context "when some players don't fall in range" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, hits: 100) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, hits: 150) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, hits: 100) }
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2011, at_bats: 500, hits: 200) }
      
      let!(:player3_stat_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, at_bats: 500, hits: 100) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 500, hits: 300) }
      
      let!(:player4_stat_2012) { FactoryGirl.create(:batting_stat, player: player4, year: 2012, at_bats: 100, hits: 100) }
      let!(:player4_stat_2013) { FactoryGirl.create(:batting_stat, player: player4, year: 2013, at_bats: 500, hits: 50) }
      
      let!(:player5_stat_2012) { FactoryGirl.create(:batting_stat, player: player5, year: 2012, at_bats: 500, hits: 50) }
      let!(:player5_stat_2013) { FactoryGirl.create(:batting_stat, player: player5, year: 2013, at_bats: 500, hits: 20) }
      
      it "returns top #{TOP} as specified" do
        players = BattingStat.batting_average_improvements opts
        expect(players.count).to eq(3)
        expect(players.first[:player_id]).to eq(player3.id)
        expect(players[1][:player_id]).to eq(player1.id)
        expect(players.last[:player_id]).to eq(player5.id)
      end
    end
    
    context "when a player has played for multiple teams" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, hits: 100) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, hits: 150) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, hits: 100) }
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2011, at_bats: 500, hits: 200) }
      
      let!(:player3_stat_teamA_2012) { FactoryGirl.create(:batting_stat, player: player3, team: 'A', year: 2012, at_bats: 300, hits: 50) }
      let!(:player3_stat_teamB_2012) { FactoryGirl.create(:batting_stat, player: player3, team: 'B', year: 2012, at_bats: 200, hits: 50) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 500, hits: 300) }
      
      let!(:player4_stat_2012) { FactoryGirl.create(:batting_stat, player: player4, year: 2012, at_bats: 100, hits: 100) }
      let!(:player4_stat_2013) { FactoryGirl.create(:batting_stat, player: player4, year: 2013, at_bats: 500, hits: 50) }
      
      let!(:player5_stat_2012) { FactoryGirl.create(:batting_stat, player: player5, year: 2012, at_bats: 500, hits: 50) }
      let!(:player5_stat_2013) { FactoryGirl.create(:batting_stat, player: player5, year: 2013, at_bats: 500, hits: 20) }
      
      it "adds up his scores across the two teams" do
        players = BattingStat.batting_average_improvements opts
        expect(players.count).to eq(3)
        expect(players.first[:player_id]).to eq(player3.id)
        expect(players.first[:start_year_calc].round(5)).to eq(0.20000)
        expect(players[1][:player_id]).to eq(player1.id)
        expect(players.last[:player_id]).to eq(player5.id)
      end
    end
  end
  
  # no need to write a spec for batting_averages since it is indirectly tested by batting_average_improvements
  
  describe "#slugging_percentages" do
    
    context 'when there is only one player' do
      # use actual numbers for 2013 MLB season so we can just compare against the real percentage
      let!(:miguel_c) { FactoryGirl.create(:miguel_c, player: player1) }  
      it 'correctly computes slugging percentage' do
        stat = BattingStat.slugging_percentages({ team: 'DET', year: 2013 })
        expect(stat.count).to eq(1)
        expect(stat.first.slugging_percentage.round(3)).to eq(0.636)
      end   
    end
    
    context 'when there are multiple players' do
      
      let!(:miguel_c) { FactoryGirl.create(:miguel_c, player: player1) } 
      let!(:max_s)    { FactoryGirl.create(:max_s, player: player2) }
      let!(:torii_h)  { FactoryGirl.create(:torii_h, player: player3) } 
      let!(:jhonny_p) { FactoryGirl.create(:jhonny_p, player: player4) }
      
      it 'returns them by slugging_percentage in desc order' do
        stat = BattingStat.slugging_percentages({ team: 'DET', year: 2013})
        expect(stat.count).to eq(4)
        
        sp = lambda { |idx| stat[idx].slugging_percentage.round(3) }
        
        expect(sp.call 0).to eq(0.667)
        expect(sp.call 1).to eq(0.636)
        expect(sp.call 2).to eq(0.465)
        expect(sp.call 3).to eq(0.457)  
      end
      
    end
    
    context 'when a player has played for multiple teams' do
      
      let!(:miguel_c) { FactoryGirl.create(:miguel_c, player: player1) } 
      let!(:max_s)    { FactoryGirl.create(:max_s, player: player2) }
      let!(:torii_h)  { FactoryGirl.create(:torii_h, player: player3) } 
      let!(:jhonny_p) { FactoryGirl.create(:jhonny_p, player: player4) }
      
      let!(:miguel_c_COL) { FactoryGirl.create(:miguel_c_COL, player: player1) }
      
      it 'ignores scores for other teams' do
        stat = BattingStat.slugging_percentages({ team: 'DET', year: 2013})
        expect(stat.count).to eq(4)
        
        sp = lambda { |idx| stat[idx].slugging_percentage.round(3) }
        
        expect(sp.call 0).to eq(0.667)
        expect(sp.call 1).to eq(0.636)
        expect(sp.call 2).to eq(0.465)
        expect(sp.call 3).to eq(0.457)  
      end
      
    end
  end
  
  describe "#fantasy_score_improvements" do
    context "when no player has above 200 at_bats" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 10) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 15) }
      
      let!(:player2_stat_2012)  { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 10) } 
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2013, at_bats: 199) }
      
      it 'returns empty collection' do
        expect(BattingStat.count).to equal(4)
        players = BattingStat.fantasy_score_improvements(opts)
        expect(players).to be_empty
      end
    end
    
    context 'when no player falls in the year range' do
      let!(:player1_stat_2010) { FactoryGirl.create(:batting_stat, player: player1, year: 2010, at_bats: 500) }
      let!(:player1_stat_2011) { FactoryGirl.create(:batting_stat, player: player1, year: 2011, at_bats: 500) }
      
      let!(:player2_stat_2010)  { FactoryGirl.create(:batting_stat, player: player2, year: 2010, at_bats: 500) } 
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500) }
      
      it 'returns empty collection' do
        expect(BattingStat.count).to equal(4)
        players = BattingStat.fantasy_score_improvements(opts)
        expect(players).to be_empty
      end
    end
    
    context "when there is just one player that qualifies" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2011, at_bats: 500) }
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500) }
      
      let!(:player3_stat_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, at_bats: 50) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 50) } 
       
      it 'returns that player with correct numbers' do
        players = BattingStat.fantasy_score_improvements(opts)
        expect(players.count).to eq(1)
        p = players.first
        expect(p[:player_id]).to eq(player1.id)
        expect(p[:start_year_calc]).to eq(player1_stat_2012.fantasy_score)
        expect(p[:end_year_calc]).to eq(player1_stat_2013.fantasy_score)
        expect(p[:improvement]).to eq(player1_stat_2013.fantasy_score - player1_stat_2012.fantasy_score)
      end
    end
    
    context "when there are multiple players" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, home_runs: 10) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, home_runs: 20) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, home_runs: 50) }
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2013, at_bats: 500, home_runs: 100) }
      
      let!(:player3_stat_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, at_bats: 500, home_runs: 100) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 500, home_runs: 200) }
      
      let!(:player4_stat_2012) { FactoryGirl.create(:batting_stat, player: player4, year: 2012, at_bats: 500, home_runs: 100) }
      let!(:player4_stat_2013) { FactoryGirl.create(:batting_stat, player: player4, year: 2013, at_bats: 500, home_runs: 50) }
      
      let!(:player5_stat_2012) { FactoryGirl.create(:batting_stat, player: player5, year: 2012, at_bats: 500, home_runs: 5) }
      let!(:player5_stat_2013) { FactoryGirl.create(:batting_stat, player: player5, year: 2013, at_bats: 500, home_runs: 2) }
      
      it "returns top #{TOP} as specified" do
        players = BattingStat.fantasy_score_improvements opts
        expect(players.count).to eq(3)
        expect(players.first[:player_id]).to eq(player3.id)
        expect(players[1][:player_id]).to eq(player2.id)
        expect(players.last[:player_id]).to eq(player1.id)
      end
    end
    
    context "when some players don't fall in range" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, home_runs: 10) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, home_runs: 20) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, home_runs: 50) }
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2011, at_bats: 500, home_runs: 100) }
      
      let!(:player3_stat_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, at_bats: 500, home_runs: 100) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 500, home_runs: 200) }
      
      let!(:player4_stat_2012) { FactoryGirl.create(:batting_stat, player: player4, year: 2012, at_bats: 100, home_runs: 100) }
      let!(:player4_stat_2013) { FactoryGirl.create(:batting_stat, player: player4, year: 2013, at_bats: 500, home_runs: 50) }
      
      let!(:player5_stat_2012) { FactoryGirl.create(:batting_stat, player: player5, year: 2012, at_bats: 500, home_runs: 5) }
      let!(:player5_stat_2013) { FactoryGirl.create(:batting_stat, player: player5, year: 2013, at_bats: 500, home_runs: 2) }
      
      it "returns top #{TOP} as specified" do
        players = BattingStat.fantasy_score_improvements opts
        expect(players.count).to eq(3)
        expect(players.first[:player_id]).to eq(player3.id)
        expect(players[1][:player_id]).to eq(player1.id)
        expect(players.last[:player_id]).to eq(player5.id)
      end
    end
    
    context "when a player has played for multiple teams" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, home_runs: 10) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, home_runs: 20) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, home_runs: 50) }
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2013, at_bats: 500, home_runs: 100) }
      
      let!(:player3_stat_teamA_2012) { FactoryGirl.create(:batting_stat, player: player3, team: 'A', year: 2012, at_bats: 300, home_runs: 50) }
      let!(:player3_stat_teamB_2012) { FactoryGirl.create(:batting_stat, player: player3, team: 'B', year: 2012, at_bats: 200, home_runs: 50) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 500, home_runs: 200) }
      
      let!(:player4_stat_2012) { FactoryGirl.create(:batting_stat, player: player4, year: 2012, at_bats: 500, home_runs: 100) }
      let!(:player4_stat_2013) { FactoryGirl.create(:batting_stat, player: player4, year: 2013, at_bats: 500, home_runs: 50) }
      
      let!(:player5_stat_2012) { FactoryGirl.create(:batting_stat, player: player5, year: 2012, at_bats: 500, home_runs: 5) }
      let!(:player5_stat_2013) { FactoryGirl.create(:batting_stat, player: player5, year: 2013, at_bats: 500, home_runs: 2) }
      
      it "adds up the scores across the two teams" do
        players = BattingStat.fantasy_score_improvements opts
        expect(players.count).to eq(3)
        expect(players.first[:player_id]).to eq(player3.id)
        expect(players[1][:player_id]).to eq(player2.id)
        expect(players.last[:player_id]).to eq(player1.id)
      end
    end
  end
  
  describe "#triple_crown_winners" do
    
    context 'when there is only one player' do
      let!(:player1_stat_2012) { FactoryGirl.create(:miguel_c, player: player1, year: 2012) }
      let!(:player1_stat_2013) { FactoryGirl.create(:miguel_c, player: player1, year: 2013) }
      
      it 'returns that player' do
        stat = BattingStat.triple_crown_winners({ years: [2012, 2013], exclude_any_at_bats_below: 200 })
        expect(stat.count).to eq(2)
        expect(stat.first[:player_id]).to eq(player1.id)
        expect(stat.last[:player_id]).to eq(player1.id)
      end   
    end
    
    context 'when there are multiple players' do
      
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 500, hits: 10, home_runs: 10, runs_batted_in: 10) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 500, hits: 10, home_runs: 20, runs_batted_in: 20) }
      let!(:player1_stat_2014) { FactoryGirl.create(:batting_stat, player: player1, year: 2014, at_bats: 500, hits: 10, home_runs: 20, runs_batted_in: 20) }
      
      let!(:player2_stat_2012) { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 500, hits: 100, home_runs: 50, runs_batted_in: 50) }
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2013, at_bats: 500, hits: 400, home_runs: 100, runs_batted_in: 100) }
      let!(:player2_stat_2014) { FactoryGirl.create(:batting_stat, player: player2, year: 2014, at_bats: 500, hits: 10, home_runs: 20, runs_batted_in: 20) }
      
      let!(:player3_stat_teamA_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, team: 'A', at_bats: 500, hits: 50, home_runs: 50, runs_batted_in: 50) }
      let!(:player3_stat_teamB_2012) { FactoryGirl.create(:batting_stat, player: player3, year: 2012, team: 'B', at_bats: 500, hits: 450, home_runs: 50, runs_batted_in: 50) }
      let!(:player3_stat_2013) { FactoryGirl.create(:batting_stat, player: player3, year: 2013, at_bats: 500, hits: 100, home_runs: 200, runs_batted_in: 200) }
      let!(:player3_stat_2014) { FactoryGirl.create(:batting_stat, player: player3, year: 2014, at_bats: 500, hits: 500, home_runs: 100, runs_batted_in: 100) }
            
      
      it 'returns them by slugging_percentage in desc order' do
        stat = BattingStat.triple_crown_winners({ years: [2012, 2013], exclude_any_at_bats_below: 200 })
        expect(stat.count).to eq(2)
        expect(stat.first[:player_id]).to eq(player3.id)
        expect(stat.last).to be_nil
      end
      
    end
  end
end