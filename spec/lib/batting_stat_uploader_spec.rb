require 'spec_helper'

def fixture_file_path(file_name)
  File.expand_path "../../fixtures/files/#{file_name}", __FILE__
end

describe BattingStatUploader do
  describe "#upload" do
    context 'when file is valid' do
      it 'creates stats in db' do
        skipped_records = BattingStatUploader.upload fixture_file_path('valid_batting_stats.csv')
        
        expect(Player.count).to eq(3)
        expect(BattingStat.count).to eq(5)
        expect(skipped_records.count).to eq(0)
        
        stats = BattingStat.all.to_a
        (0..4).each do |i|
          stats[i].at_bats.should eq(i + 1 + 10)
          stats[i].hits.should eq(i + 1 + 11)
          stats[i].hits.should eq(i + 1 + 11)
          stats[i].doubles.should eq(i + 1 + 12)
          stats[i].triples.should eq(i + 1 + 13)
          stats[i].home_runs.should eq(i + 1 + 14)
          stats[i].runs_batted_in.should eq(i + 1 + 15)
          stats[i].stolen_bases.should eq(i + 1 + 16)
          stats[i].caught_stealing.should eq(i + 1 + 17)
        end
      end
      
      it 'handles updating existing records' do
        skipped_records = BattingStatUploader.upload fixture_file_path('valid_has_existing_batting_stats.csv')
        expect(Player.count).to eq(3)
        expect(BattingStat.count).to eq(5)
        expect(skipped_records.count).to eq(0)
        
        updated_stat_player = Player.where(player_legacy_id: 'legacy2').first
        updated_stat = updated_stat_player.batting_stats.first
        updated_stat.at_bats.should eq(50)
      end
    end
    
    context 'when file contains missing player_legacy_id, year or team' do
      it 'skips records with missing player_legacy_id, year or team' do
        skipped_records = BattingStatUploader.upload fixture_file_path('valid_missing_id_year_or_team_batting_stats.csv')
        expect(BattingStat.count).to eq(4)
        expect(skipped_records.count).to eq(4)
      end
    end
    
    context 'when file is of invalid format' do
      it 'creates zero records' do
        skipped_records = BattingStatUploader.upload fixture_file_path('invalid_format_batting_stats.txt')
        expect(BattingStat.count).to eq(0)
        expect(skipped_records.count).to eq(1)
      end
    end
   
  end
end
