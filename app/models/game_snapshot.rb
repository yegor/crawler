class GameSnapshot < ActiveRecord::Base
  belongs_to :game
  belongs_to :meta_data
  belongs_to :chart_snapshot
  
  
end
