namespace :crawler do
  desc "Syncronize with AppStore"
  task :sync => :environment do
    AppStore::Crawler.fetch_charts
    AppStore::Crawler.fetch_meta_data
  end
end