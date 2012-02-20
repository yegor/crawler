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
    params[:country]    ||= "United States"
    params[:genre]      ||= "games"
    params[:kind]       ||= "toppaidapplications"
    params[:game_id]    ||= 343200656
    params[:date_since] ||= 1.week.ago
    params[:date_till]  ||= 0.days.ago
    
    @timespan = (params[:date_since].to_date .. params[:date_till].to_date)
    
    @charts = Chart.find_or_initialize_with(params)
    @game = Game.find_by_itunes_id(params[:game_id])
    
    @rankings = Stats.raking_over_time(:games => [@game], :charts => @charts, :timespan => @timespan) rescue {}   
    @table_rankings = @rankings.values.first.values.first rescue {}
    
    @metas = MetaData.with_country.includes(:game).where(:itunes_id => params[:game_id]).all
    @meta = @metas.detect { |m| (params[:country] & m.country_array.split("|")).present? } || @metas.sort_by(&:updated_at).last
  end

end
