class Chart < ActiveRecord::Base
  include AppStore::RSS
  
  validates_presence_of :country
  validates_inclusion_of :kind, :in => AppStore::RSS::KINDS
  
  has_many :chart_snapshots
end
