namespace :charts do
  desc "Creates initial charts set"
  task :initial => :environment do
    Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "toppaidapplications", :genre => nil
    # Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "toppaidapplications", :genre => "games"
    # 
    # Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "topfreeapplications", :genre => nil
    # Chart.create :country => Chart::COUNTRIES["United States"], :limit => 400, :kind => "topfreeapplications", :genre => "games"
  end
end