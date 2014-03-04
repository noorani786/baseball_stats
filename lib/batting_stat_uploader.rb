require 'CSV'

# This class will CREATE or UPDATE batting-stats by reading a CSV-formatted input file.
# only supports CSV format.
# It will create a player by playerId if doesn't already exist in the database.
# any records that don't contain a value for playerId, year and team will be skipped.
class BattingStatUploader
  def self.upload(file_path)
    skipped_records = []
    CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |row|
      row_hash = row.to_hash
      if row_hash[:playerid].present? && row_hash[:yearid].present? && row_hash[:teamid].present?
        player = Player.where(player_legacy_id: row_hash[:playerid]).first_or_create
        batting_stats = player.batting_stats.where(year: row_hash[:yearid].to_i, team: row_hash[:teamid]).first_or_create
        batting_stats.update_attributes({
          at_bats:          try_to_i(row_hash[:ab]),
          hits:             try_to_i(row_hash[:h]),
          doubles:          try_to_i(row_hash['2b'.to_sym]),
          singles:          try_to_i(row_hash['3b'.to_sym]),
          home_runs:        try_to_i(row_hash[:hr]),
          runs_batted_in:   try_to_i(row_hash[:rbi]),
          stolen_bases:     try_to_i(row_hash[:sb]),
          caught_stealing:  try_to_i(row_hash[:cs])
          })
      else
        skipped_records << row_hash
      end
    end
    skipped_records
  end
  
  def self.try_to_i(value)
    value.to_i if value.present?
  end
end