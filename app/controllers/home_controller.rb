class HomeController < ApplicationController
  
  include AppStore::ChartConfig
  
  before_filter :prepare_params
  
  def index
    @games = MetaData.select("game_id as id, name").group("game_id").limit(100).all
    @countries = SUPER_COUNTRIES
  end
  
  def filter
    index
  end

  def paid
    @rankings = Stats.raking_over_time(:game => @game, :charts => @charts.where(:kind => %w(toppaidapplications toppaidipadapplications)).all)
    @title = "Top Paid Rankings"
    render "data"
  end
  
  def grossing
    @rankings = Stats.raking_over_time(:game => @game, :charts => @charts.where(:kind => %w(topgrossingapplications topgrossingipadapplications)).all)
    @title = "Top Grossing Rankings"
    render "data"
  end
  
  def free
    @rankings = Stats.raking_over_time(:game => @game, :charts => @charts.where(:kind => %w(topfreeapplications topfreeipadapplications)).all)
    @title = "Top Free Rankings"
    render "data"
  end
  
protected

  def prepare_params
    @game = Game.find_by_id(params[:filter][:game]) rescue nil
    @game = Game.find(2137) if @game.blank?
    countries = params[:filter][:countries].select { |k, v| v == "1" }.keys rescue []
    countries = [SUPER_COUNTRIES.last] if countries.blank?
    @charts = Chart.where(:country => countries)
  end

end
