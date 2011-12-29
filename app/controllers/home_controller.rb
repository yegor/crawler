class HomeController < ApplicationController
  
  include AppStore::ChartConfig
  
  before_filter :prepare_params
  
  def index
    @filter = Filter.new(:game_names => %w(Angry\ Birds), :chart_kinds => %w(toppaidapplications), :countries => %w(United\ States))
  end
  
  def filter
    index
  end
  
  def autocomplete_game
    meta_data = MetaData.group(:game_id).where(["meta_data.name like ?", "%#{ params[:q] }%"]).limit(15)
    render :text => meta_data.map(&:name).join("\n")
  end

  def chart
    @rankings = Stats.raking_over_time(:games => @filter.games, :charts => @filter.charts)
    render "data"
  end
  
protected

  #  Attempts to preload the filter.
  #
  def prepare_params
    @filter = Filter.new(params[:filter_settings])
  end

end
