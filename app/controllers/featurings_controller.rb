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
    params[:genre] ||= "games"
    
    @imports  = Import.where(["imports.created_at >= ? AND imports.created_at < ?", params[:date].to_date.beginning_of_day, params[:date].to_date.beginning_of_day + 24.hours]).order
    @charts   = Chart.where(:country => params[:country].split(","), :genre => params[:genre].split(",")).all
    
    @features = ChartSnapshot.select("game_snapshots.*, charts.country as chart_country, meta_data.*, pages.id as page_id, pages.type as page_type, pages.title as page_title, featurings.type as featuring_type, featurings.rank as featuring_rank").where(:chart_id => @charts, :import_id => @imports).joins([:chart, {:game_snapshots => [:meta_data, {:featurings => :page}]}])
  end

end
