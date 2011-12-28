require 'open-uri'
require 'json'

# FIXME: perfomance
module AppStore  
  class Crawler
    class << self
      
      #  Fetches each chart with the recent AppStore rss feeds
      #
      def fetch_charts
        import_id = Import.create.id
        
        Chart.find_in_batches(:batch_size => 5) do |combined_charts|
          pids = combined_charts.map do |chart|
            fork do
              ActiveRecord::Base.establish_connection
              
              chart_snapshot = ChartSnapshot.create :import_id => import_id, :chart => chart
          
              puts "Fetching chart #{chart.url.to_s}... \n"
              old_games_count = Game.count
              old_meta_data_count = MetaData.count
          
              ids = []
              feed = AppStore::Crawler.load(chart.url)["feed"]["entry"]
          
              puts "Parsing appstore feed"
              feed.each_with_index do |entry_attributes, index|
                entry = AppStore::JSON::ChartEntry.new entry_attributes

                game = Game.find_or_create_from_appstore :entry => entry
                meta_data = MetaData.find_or_create_from_appstore :entry => entry, :game => game

                ids << GameSnapshot.create(:game => game, :meta_data => meta_data, :chart_snapshot => chart_snapshot, :rank => (index + 1)).itunes_id
              end
          
              puts "\t #{Game.count - old_games_count} new games added. \n"
              puts "\t #{MetaData.count - old_meta_data_count} new meta datas added. \n"
          
              fetch_meta_data :country => chart.country, :ids => ids
            end
          end
          
          pids.each { |pid| Process.waitpid(pid) }
        end
      end
      
      #  Fetches meta data for loaded games
      #      
      def fetch_meta_data(opt = {})
        puts "Updating #{opt[:ids].size} game snapshot objects through lookup API... \n"

        opt[:ids].each_slice(200).each do |ids|
          # ActiveRecord::Base.transaction do
            AppStore::Crawler.load(URI("#{AppStore::ChartConfig::ITUNES_LOOKUP_BASE_URL}?id=#{ids.join(",")}&country=#{AppStore::ChartConfig::COUNTRIES[opt[:country]]}"))["results"].each do |game_meta_data|
              entry = AppStore::JSON::LookupEntry.new(game_meta_data)
              GameSnapshot.includes(:meta_data).where(:itunes_id => entry.itunes_id).first.update_with_entry(entry)
            end
          # end
        end
      end
      
      #  Fetches RSS feed with specified url   
      #
      #  * <tt>feed_url</tt>:: +URI::HTTP+ the feed url
      #
      def load(feed_url)
        json_file = open(feed_url)
        (::JSON.parse(json_file.read)).tap { json_file.close }
      end
    end
  end
end