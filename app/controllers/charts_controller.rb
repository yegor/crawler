class ChartsController < ApplicationController
  
  before_filter :prepare_params
  
  def show
    respond_to do |format|
      format.html do 
        charts = Chart.where(:country => "United States", :genre => "games", :kind => %w(topfreeapplications toppaidapplications topgrossingapplications)).all
        @snapshots = ChartSnapshot.with_includes_for_charts.where(:chart_id => charts, :import_id => Import.last)
      end
      
      format.js do
        params[:genre] = nil if params[:genre] == "all"
        chart = Chart.where(:country => params[:country], :genre => params[:genre], :kind => params[:kind]).first
        @snapshot = ChartSnapshot.with_includes_for_charts.where(:chart_id => chart, :import_id => Import.last).first
      end
    end
  end

protected

  #  Prepares params to be used.
  #
  def prepare_params
    
  end

end
