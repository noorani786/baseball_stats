require_relative '../lib/player_uploader'

puts "Seeding players from 'inputs/Master-small.csv'..."
Player.reset_column_information
skipped_records = PlayerUploader.upload 'inputs/Master-small.csv'
puts "Done seeding players."
puts "The following records were skipped because they did not specify a playerId:"
puts skipped_records


