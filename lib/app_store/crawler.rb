require 'open-uri'
require 'json'

# FIXME: perfomance
module AppStore  
  class Crawler
    class << self
      
      #  Fetches each chart with the recent AppStore rss feeds
      #
      def fetch_charts
        import = Import.create

        Chart.find_in_batches(:batch_size => 10) do |charts|
          charts.each do |chart|
            chart_snapshot = ChartSnapshot.create :import => import, :chart => chart
            
            AppStore::Crawler.load(chart.url)["feed"]["entry"].each_with_index do |entry_attributes, index|
              entry = AppStore::JSON::ChartEntry.new entry_attributes
              
              game = Game.find_or_create_from_appstore :entry => entry
              meta_data = MetaData.find_or_create_from_appstore :entry => entry, :game => game
              
              GameSnapshot.create :game => game, :meta_data => meta_data, :chart_snapshot => chart_snapshot, :rank => (index + 1)
            end
            
          end
        end
      end
      
      #  Fetches meta data for loaded games
      #      
      def fetch_meta_data
        MetaData.not_yet_sexy.find_in_batches(:batch_size => 100) do |meta_datas|
            ids = meta_datas.collect(&:itunes_id).join(",")
            AppStore::Crawler.load(URI("#{AppStore::ChartConfig::ITUNES_LOOKUP_BASE_URL}?id=#{ids}"))["results"].each do |game_meta_data|
              entry = AppStore::JSON::LookupEntry.new(game_meta_data)
              
              # We need to refetch each metadata as we a re not sure if Apple's api give us results for all requested games
              MetaData.where(:itunes_id => entry.itunes_id).first.update_attributes entry.instance_values.symbolize_keys.merge(:appstore_syncronized => true)
            end
        end
      end
      
      #  Fetches RSS feed with specified url   
      #
      #  * <tt>feed_url</tt>:: +URI::HTTP+ the feed url
      #
      def load(feed_url)
        ::JSON.parse open(feed_url).read
      end
    end
  end
end