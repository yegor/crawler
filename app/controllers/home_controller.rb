class HomeController < ApplicationController
  
  include AppStore::ChartConfig
  
  before_filter :prepare_params
  
  def index
    @filter ||= Filter.new(:time_from => 1.week.ago, :time_to => Time.now, :game_names => %w(Angry\ Birds), :categories => %w(all games), :chart_kinds => %w(toppaidapplications), :countries => %w(United\ States))
  end
  
  def filter
    index
  end
  
  def by_publisher
    games = MetaData.where(:publisher => @filter.publisher).group(&:game_id).select("name")
    @filter.game_names = games.map(&:name)
  end
  
  def top
    import = Import.last(:include => {:chart_snapshots => [{:game_snapshots => [:game, :meta_data]}, :chart]})
    @snapshots = import.chart_snapshots.select { |cs| cs.chart.country == "United States" }
  end
  
  def autocomplete_game
    meta_data = MetaData.group(:game_id).where(["meta_data.name like ?", "%#{ params[:q] }%"]).limit(15)
    render :text => meta_data.map(&:name).join("\n")
  end
  
  def autocomplete_publisher
    publishers = MetaData.where(["publisher like CONCAT('%', '?', '%')", 'g5']).select("DISTINCT publisher")
    render :text => publishers.map(&:publisher).join("\n")
  end

  def chart
    @rankings = Stats.raking_over_time(:games => @filter.games, :charts => @filter.charts, :timespan => @filter.time_from.to_date..@filter.time_to.to_date)
    render "data"
  end
  
protected
  
  #  Attempts to preload the filter.
  #
  def prepare_params
    params[:filter_settings].tap do |fs|
      fs[:countries].compact!
      fs[:chart_kinds].compact!
      
      fs[:time_from] = "#{ fs.delete("time_from(1i)") }-#{ fs.delete("time_from(2i)") }-#{ fs.delete("time_from(3i)") }".to_date if fs[:"time_from(1i)"].present?
      fs[:time_to] = "#{ fs.delete("time_to(1i)") }-#{ fs.delete("time_to(2i)") }-#{ fs.delete("time_to(3i)") }".to_date if fs[:"time_to(1i)"].present?
    end if params[:filter_settings].present?
  
    @filter = Filter.new(params[:filter_settings]) if params[:filter_settings]
  end

end
