namespace :charts do
  desc "Creates initial charts set"
  task :initial => :environment do
    # Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "toppaidapplications", :genre => nil
    # Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "toppaidapplications", :genre => "games"
    # 
    # Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "topfreeapplications", :genre => nil
    # Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "topfreeapplications", :genre => "games"
    
    AppStore::ChartConfig::SUPER_COUNTRIES.each do |country|
      AppStore::ChartConfig::SUPER_KINDS.each do |kind|
        AppStore::ChartConfig::SUPER_GENRES.each do |genre|
          chart = Chart.create :country => country, :limit => 400, :kind => kind, :genre => genre
        end
      end
    end
  end
end