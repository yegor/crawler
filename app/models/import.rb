# == Schema Information
#
# Table name: imports
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Import < ActiveRecord::Base
  has_many :chart_snapshots
  
end

