class GameSnapshot < ActiveRecord::Base
  belongs_to :game
  belongs_to :meta_data
  belongs_to :chart_snapshot
  
  validates_presence_of :rank
  validates_presence_of :game
  validates_presence_of :meta_data
  validates_presence_of :chart_snapshot
end
