require 'spec_helper'

describe PlayerUploader do
  describe "#upload" do
    context 'when file is valid' do
      it 'creates players in db' do
        skipped_records = PlayerUploader.upload fixture_file_path('valid_players.csv')
        expect(Player.count).to eq(3)
        expect(skipped_records.count).to eq(0)
        players = Player.all.to_a
        (0..2).each do |i|
          players[i].first_name.should eq("First #{i + 1}")
          players[i].last_name.should eq("Last #{i + 1}")
          players[i].player_legacy_id.should eq("Legacy#{i + 1}")
          players[i].birth_year.should eq(i + 1)
        end
      end
      
      it 'handles updating existing records' do
        skipped_records = PlayerUploader.upload fixture_file_path('valid_has_existing_players.csv')
        expect(Player.count).to eq(3)
        expect(skipped_records.count).to eq(0)
        
        updated_player = Player.where(player_legacy_id: 'Legacy2').first
        updated_player.first_name.should eq('First 2')
        updated_player.last_name.should eq('Last 2')
        updated_player.birth_year.should eq(2)  
      end
    end
    
    context 'when file contains missing player_legacy_id' do
      it 'skips records with missing player_legacy_id' do
        skipped_records = PlayerUploader.upload fixture_file_path('valid_missing_id_players.csv')
        expect(Player.count).to eq(2)
        expect(skipped_records.count).to eq(1)
        Player.last.player_legacy_id.should eq("Legacy3")
        Player.last.first_name.should be_nil
        Player.last.birth_year.should eq(nil)
        Player.last.last_name.should eq("Last 3")
      end
    end
    
    context 'when file is of invalid format' do
      it 'creates zero records' do
        skipped_records = PlayerUploader.upload fixture_file_path('invalid_format_players.txt')
        expect(Player.count).to eq(0)
        expect(skipped_records.count).to eq(1)
      end
    end
   
  end
end


