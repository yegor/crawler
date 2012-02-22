class FeaturingsController < ApplicationController
  
  before_filter :parse_params
  
  def show
  end
  
protected

  # Prepares the data.
  #
  def parse_params
    params[:country] ||= "United States"
    params[:date] ||= Date.today
    
    @imports  = Import.where(["imports.created_at >= ? AND imports.created_at < ?", params[:date].to_date.beginning_of_day, params[:date].to_date.beginning_of_day + 24.hours]).all
    @charts   = Chart.where(:country => params[:country], :genre => "games", :kind => "toppaidapplications").all
    
    @features = ChartSnapshot.select("*").where(:chart_id => @charts, :import_id => @imports).joins(:game_snapshots => [:meta_data, {:featurings => :page}])
  end

end
