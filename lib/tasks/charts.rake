namespace :charts do
  desc "Creates initial charts set"
  task :initial => :environment do
    AppStore::ChartConfig::SUPER_COUNTRIES.each do |country|
      AppStore::ChartConfig::SUPER_KINDS.each do |kind|
        AppStore::ChartConfig::SUPER_GENRES.each do |genre|
          chart = Chart.create :country => country, :limit => 400, :kind => kind, :genre => genre
        end
      end
    end
  end
end