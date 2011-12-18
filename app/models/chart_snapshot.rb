class ChartSnapshot < ActiveRecord::Base
  belongs_to :chart
  belongs_to :import
  
  
end
