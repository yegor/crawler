class ChartSnapshot < ActiveRecord::Base
  belongs_to :chart
  belongs_to :import
  has_many :game_snapshots
  
end
