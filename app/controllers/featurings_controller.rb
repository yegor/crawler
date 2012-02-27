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
    
    @countries = params[:country].split(",").uniq
    
    @imports  = Import.where(["imports.created_at >= ? AND imports.created_at < ?", params[:date].to_date.beginning_of_day, params[:date].to_date.beginning_of_day + 24.hours]).order

    @features = FeaturingSnapshot.where(:import_id => @imports, :country => @countries).
                                  joins("INNER JOIN featurings ON featurings.id = featuring_snapshots.featuring_id").
                                  joins("INNER JOIN pages ON pages.id = featurings.page_id").
                                  select("featuring_snapshots.itunes_id as itunes_id, featuring_snapshots.country as chart_country, pages.id as page_id, pages.type as page_type, pages.title as page_title, featurings.type as featuring_type, featurings.rank as featuring_rank")
  
    @metas = MetaData.where(:itunes_id => @features.map(&:itunes_id).uniq).group(:itunes_id).index_by(&:itunes_id)
  end

end
