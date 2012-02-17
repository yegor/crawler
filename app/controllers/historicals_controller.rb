class HistoricalsController < ApplicationController
  
  before_filter :parse_params
  
  def show
  end
  
  def ranking
  end
  
protected
  
  #  Parses params and sets defaults if needed.
  #
  def parse_params
    params[:country] ||= "United States"
    params[:genre] ||= "games"
    params[:kind] ||= "toppaidapplications"
    params[:game_id] ||= 343200656
    
    @timespan = 1.year.ago..Date.today
    
    @charts = Chart.where(:country => params[:country], :genre => params[:genre], :kind => params[:kind]).all
    @chart_snapshots = ChartSnapshot.with_includes_for_charts.where(:chart_id => @charts, :import_id => Import.last).all
    @games = Game.where(:itunes_id => params[:game_id]).all
    
    @game_snapshot = GameSnapshot.find_by_game_id_and_chart_snapshot_id(@games, @chart_snapshots)
    @rankings = Stats.raking_over_time(:games => @games, :charts => @charts, :timespan => @timespan) rescue []
    @table_rankings = @rankings.values.first.values.first rescue {}
  end

end
