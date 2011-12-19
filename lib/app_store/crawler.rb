require 'open-uri'
require 'json'

module AppStore  
  class Crawler
    class << self
      
      #  Syncronizes each chart with the recent AppStore rss feeds
      #
      def sync
        import = Import.create

        Chart.find_in_batches(:batch_size => 10) do |charts|
          charts.each do |chart|
            chart_snapshot = ChartSnapshot.create :import => import, :chart => chart
            
            AppStore::Crawler.fetch(chart.url).each_with_index do |entry_attributes, index|
              entry = AppStore::JSON::Entry.new entry_attributes
              
              game = Game.find_or_create_from_appstore :entry => entry
              meta_data = MetaData.find_or_create_from_appstore :entry => entry, :game => game
              
              GameSnapshot.create :game => game, :meta_data => meta_data, :chart_snapshot => chart_snapshot, :rank => (index + 1)
            end
            
          end
        end
      end
      
      #  Fetches RSS feed with specified url   
      #
      #  * <tt>feed_url</tt>:: +URI::HTTP+ the feed url
      #
      def fetch(feed_url)
        ::JSON.parse(open(feed_url).read)["feed"]["entry"]
      end
    end
  end
end