class Game < ActiveRecord::Base
  has_many :game_snapshots
  
  validates_presence_of :release_date
end
