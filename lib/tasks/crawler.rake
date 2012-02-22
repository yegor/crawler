namespace :crawler do
  desc "Syncronize with AppStore"
  task :sync => :environment do
    AppStore::Crawler.fetch_charts
  end
  
  desc "Synchronize featurings"
  task :features => :environment do
    AppStore::Crawler.fetch_features
  end
end