namespace :crawler do
  desc "Syncronize with AppStore"
  task :sync => :environment do
    AppStore::Crawler.sync    
  end
end