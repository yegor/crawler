class PublishersController < ApplicationController
  
  before_filter :parse_params
  
  def show
  end
  
protected

  #  Parses params and prepares the data to be displayed.
  #
  def parse_params
    params[:publisher] ||= "Chillingo Ltd"
    
    @metas = MetaData.where(:publisher => params[:publisher]).
                      group(&:itunes_id).
                      group_by(&:itunes_id)
                      
    @ranks = GameSnapshot.where(:itunes_id => @metas.keys, :imports => {:id => Import.last}).
                          joins(:chart_snapshot => [:chart, :import]).
                          select("game_snapshots.*, charts.country as country, charts.genre as genre, charts.kind as kind").group_by(&:itunes_id)
  
    @sorted_itunes_id = @metas.keys.sort_by { |id| (@ranks[id] || []).map(&:rank).min || 401 }
  end
  
end