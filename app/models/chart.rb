class Chart < ActiveRecord::Base
  include AppStore::ChartConfig
  
  validates_presence_of :country
  validates_inclusion_of :kind, :in => KINDS
  
  has_many :chart_snapshots
  
  #  Returns the RSS url for fetching chart-specific data
  #
  def url
    self.class.url_for :country => country, :limit => limit, :genre => genre, :kind => kind
  end
  
end