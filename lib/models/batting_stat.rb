class BattingStat < ActiveRecord::Base
  belongs_to :player
  
  validates :year, presence: true
  validates :team, presence: true
  
  # there can only be one record per player/team/year combination
  validates_uniqueness_of :player_id, scope: [:team, :year]
end