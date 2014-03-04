require_relative '../lib/player_uploader'
require_relative '../lib/batting_stat_uploader'

puts "Seeding players from 'inputs/Master-small.csv'..."
Player.reset_column_information
skipped_records = PlayerUploader.upload 'inputs/Master-small.csv'
puts "Done seeding players."
puts "The following records were skipped because they did not specify a playerId:"
puts skipped_records

puts "Seeding batting stats from 'input/Batting-07-12.csv'..."
BattingStat.reset_column_information
skipped_records = BattingStatUploader.upload 'inputs/Batting-07-12.csv'
puts "Done seeding batting stats."
puts "The following records were skipped because they did not specify a playerId, year or team:"
puts skipped_records
