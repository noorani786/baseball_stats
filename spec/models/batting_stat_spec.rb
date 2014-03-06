require 'spec_helper'

describe BattingStat do
    
  let(:player1) { FactoryGirl.create(:player) }
  let(:player2) { FactoryGirl.create(:player) }
  let(:player3) { FactoryGirl.create(:player) }
  let(:player4) { FactoryGirl.create(:player) }
  let(:player5) { FactoryGirl.create(:player) }
  
  TOP = 3
  let(:opts) { { top: TOP, start_year: 2012, end_year: 2013, exclude_any_below_at_bats: 200} }
  
  describe "#players_by_batting_average_improvements" do
    context "when no player has above 200 at_bats" do
      let!(:player1_stat_2012) { FactoryGirl.create(:batting_stat, player: player1, year: 2012, at_bats: 10) }
      let!(:player1_stat_2013) { FactoryGirl.create(:batting_stat, player: player1, year: 2013, at_bats: 15) }
      
      let!(:player2_stat_2012)  { FactoryGirl.create(:batting_stat, player: player2, year: 2012, at_bats: 10) } 
      let!(:player2_stat_2013) { FactoryGirl.create(:batting_stat, player: player2, year: 2013, at_bats: 199) }
      
      it 'returns empty collection' do
        expect(BattingStat.count).to equal(4)
        players = BattingStat.players_by_batting_average_improvements(opts)
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
        players = BattingStat.players_by_batting_average_improvements(opts)
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
        players = BattingStat.players_by_batting_average_improvements(opts)
        expect(players.count).to eq(1)
        p = players.first
        expect(p[:player_id]).to eq(player1.id)
        expect(p[:start_year_average]).to eq(player1_stat_2012.batting_average)
        expect(p[:end_year_average]).to eq(player1_stat_2013.batting_average)
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
      
      let!(:player5_stat_2012) { FactoryGirl.create(:batting_stat, player: player5, year: 2012, at_bats: 100, hits: 100) }
      let!(:player5_stat_2013) { FactoryGirl.create(:batting_stat, player: player5, year: 2013, at_bats: 200, hits: 200) }
      
      it "returns top #{TOP} as specified" do
        players = BattingStat.players_by_batting_average_improvements opts
        expect(players.count).to eq(3)
        expect(players.first[:player_id]).to eq(player3.id)
        expect(players[1][:player_id]).to eq(player2.id)
        expect(players.last[:player_id]).to eq(player1.id)
      end
      
    end
  end
end