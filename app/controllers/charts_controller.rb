class ChartsController < ApplicationController
  
  before_filter :prepare_params
  
  def show
    respond_to do |format|
      format.html do 
        @charts = Chart.find_or_initialize_with(:country => "United States", :genre => "games", :kind => %w(topfreeapplications toppaidapplications topgrossingapplications))
        @snapshots = ChartSnapshot.with_includes_for_charts.where(:chart_id => @charts, :import_id => Import.last)
      end
      
      format.js do
        @chart = Chart.find_or_initialize_with(params).first
        @snapshot = ChartSnapshot.with_includes_for_charts.where(:chart_id => @chart, :import_id => Import.last).first
      end
    end
  end

protected

  #  Prepares params to be used.
  #
  def prepare_params
    
  end

end
