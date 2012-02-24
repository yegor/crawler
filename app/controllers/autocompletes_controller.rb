class AutocompletesController < ApplicationController
  
  def game
    meta_data = MetaData.where(:id => MetaData.search_for_ids(params[:term])).group(:itunes_id)
    render :json => meta_data.map { |meta| {:value => meta.itunes_id, :label => meta.name} }
  end

  def publisher
    meta_data = MetaData.where(:id => MetaData.search_for_ids(:conditions => {:publisher => params[:term]})).group(:publisher)
    render :json => meta_data.map { |meta| {:value => meta.publisher, :label => meta.publisher} }
  end

end
