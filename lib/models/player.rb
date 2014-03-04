class Player < ActiveRecord::Base
  
  validates :player_legacy_id, uniqueness: true
  
  has_many :batting_stats
end