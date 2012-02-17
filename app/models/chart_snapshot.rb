# == Schema Information
#
# Table name: chart_snapshots
#
#  id         :integer(4)      not null, primary key
#  import_id  :integer(4)
#  chart_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_chart_snapshots_on_import_id  (import_id)
#  index_chart_snapshots_on_chart_id   (chart_id)
#

class ChartSnapshot < ActiveRecord::Base
  belongs_to :chart
  belongs_to :import
  has_many :game_snapshots, :order => "rank ASC"
  
  scope :with_includes_for_charts, includes(:game_snapshots => [:game, :meta_data])
  
end

