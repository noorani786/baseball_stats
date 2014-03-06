class Player < ActiveRecord::Base
  
  validates :player_legacy_id, uniqueness: true
  
  has_many :batting_stats
  
  def full_name
    "#{first_name} #{last_name}"
  end
end