# == Schema Information
#
# Table name: charts
#
#  id         :integer(4)      not null, primary key
#  country    :string(255)
#  limit      :integer(4)
#  kind       :string(255)
#  genre      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Chart < ActiveRecord::Base
  include AppStore::ChartConfig
  
  validates_presence_of :country
  validates_inclusion_of :kind, :in => KINDS
  validates_inclusion_of :genre, :in => GENRES, :allow_nil => true
  
  has_many :chart_snapshots
  
  class << self
    
    #  Finds or initializes the charts by settings passed.
    #
    #  * <tt>attrs</tt>:: A +Hash+ of attributes to initialize the chart with.
    #
    def find_or_initialize_with(attrs)
      countries, genres, kinds = attrs[:country].to_a, attrs[:genre].to_a, attrs[:kind].to_a
      
      countries.product(genres).product(kinds).map(&:flatten).map do |settings|
        settings[1] = nil if ["all", ""].include?(settings[1])
        find_or_initialize_by_country_and_genre_and_kind(*settings)
      end
    end
    
  end
  
  #  Returns the RSS url for fetching chart-specific data
  #
  def url
    self.class.url_for :country => country, :limit => limit, :genre => genre, :kind => kind
  end
  
end
