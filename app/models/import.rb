class Import < ActiveRecord::Base
  has_many :chart_snapshots
  
end
