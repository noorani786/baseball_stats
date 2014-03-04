require 'CSV'

# This class will CREATE or UPDATE players by reading a CSV-formatted input file.
# only supports CSV format.
# skips any records that doesn't contain a value for playerId. note that we've made the decision to skip records without playerid since
# our purpose here is to compute stats for players and not to do "data cleanup".  And in order to compute stats for a player, the player
# must have a playerId
class PlayerUploader
  def self.upload(file_path)
    skipped_records = []
    CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |row|
      row_hash = row.to_hash
      if row_hash[:playerid].present?
        player = Player.find_or_initialize_by_player_legacy_id row_hash[:playerid]
        player.update_attributes({
          first_name: row_hash[:namefirst],
          last_name:  row_hash[:namelast],
          birth_year: row_hash[:birthyear].present? ? row_hash[:birthyear].to_i : nil
          })
      else
        skipped_records << row_hash
      end
    end
    skipped_records
  end
end