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
    
    @imports  = Import.where(["imports.created_at >= ? AND imports.created_at <= ?", params[:date].to_date.beginning_of_day, params[:date].to_date.beginning_of_day + 24.hours])
    @features = @imports.joins(:chart_snapshots => {:game_snapshots => :featurings})
  end

end
