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
        
        Chart.find_in_batches(:batch_size => 15) do |charts|
          pids = charts.map do |chart|
            fork do
              ActiveRecord::Base.establish_connection
              # ActiveRecord::Base.logger = Logger.new(STDOUT)

              chart_snapshot = ChartSnapshot.create :import_id => import_id, :chart => chart
            
              puts "Fetching chart #{chart.url.to_s}... \n"
              feed = AppStore::Crawler.load(chart.url)["feed"]["entry"]
            
              puts "Parsing appstore feed"
              entries = feed.map.with_index { |attrs, rank| AppStore::JSON::ChartEntry.new(attrs.merge("rank" => rank + 1)) }.index_by(&:itunes_id)
              self.fetch_meta_data(entries, chart.country)
              
              games = Game.bulk_create(entries)
              metas = MetaData.bulk_create(games, entries).index_by(&:game_id)
              GameSnapshot.bulk_create(games, metas, entries, chart_snapshot)
            end
          end
          
          pids.each { |pid| Process.wait(pid) }
        end
      end
      
      def fetch_features
        import_id = Import.last.id
        pids = Chart.all.group_by(&:country).map do |country, charts|
          fork do
            ActiveRecord::Base.establish_connection
            
            features = AppStore::ItunesStore.crawl(country)
            snapshots = GameSnapshot.select("game_snapshots.*").group("game_snapshots.id").joins("INNER JOIN chart_snapshots ON chart_snapshots.chart_id IN (#{charts.map(&:id).join ", "}) AND chart_snapshots.import_id = #{ import_id.to_i } AND chart_snapshots.id = game_snapshots.chart_snapshot_id").where(:itunes_id => features.keys)
            
            bulk_sql = snapshots.map do |snapshot|
              features[ snapshot.itunes_id.to_s ].map do |feature|
                "(#{ snapshot.id }, #{ feature.id })"
              end
            end.flatten.join(", ")
            
            GameSnapshot.connection.execute "INSERT IGNORE INTO featurings_game_snapshots (game_snapshot_id, featuring_id) VALUES #{ bulk_sql }"
          end
        end
        
        pids.each { |pid| Process.wait(pid) }
      end
      
      #  Fetches meta data for loaded games
      #      
      def fetch_meta_data(entries, country)
        puts "Updating #{entries.size} game snapshot objects through lookup API... \n"
        
        all_ids = entries.keys
        
        all_ids.each_slice(200).each do |ids|
          AppStore::Crawler.load(URI("#{AppStore::ChartConfig::ITUNES_LOOKUP_BASE_URL}?id=#{ids.join(",")}&country=#{AppStore::ChartConfig::COUNTRIES[country]}"))["results"].each do |game_meta_data|
            lookup_entry = AppStore::JSON::LookupEntry.new(game_meta_data)
            entries[ lookup_entry.itunes_id ].lookup_entry = lookup_entry
          end
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