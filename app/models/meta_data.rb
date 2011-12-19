class MetaData < ActiveRecord::Base
  serialize :genres, Array
  serialize :screenshots, Array
  
  belongs_to :game
  
  validates_presence_of :name
  validates_presence_of :summary
  validates_presence_of :rights
  validates_presence_of :publisher
  validates_presence_of :release_date
  validates_presence_of :screenshot_url
  validates_presence_of :icon_url
  validates_presence_of :itunes_id
  
  scope :not_yet_sexy, where(:appstore_syncronized => false)
  
  class << self
    def find_or_create_from_appstore(opt = {})
      new_meta_data = MetaData.new opt[:entry].instance_values.symbolize_keys.merge(:game_id => opt[:game].id)
      latest_meta_data = MetaData.where(:game_id => opt[:game].id).last
      
      if latest_meta_data.blank?
        new_meta_data.new_version = true
        new_meta_data.save
        return new_meta_data
      end
      
      if latest_meta_data.release_date.to_i != new_meta_data.release_date.to_i
        new_meta_data.new_version = true 
      end
      
      unless latest_meta_data == new_meta_data
        new_meta_data.save
        return new_meta_data
      end
      
      return latest_meta_data
    end
  end
  
  def ==(another)
    self.name == another.name && self.summary == another.summary &&  self.rights == another.rights && self.publisher == another.publisher &&
    self.screenshot_url == another.screenshot_url && self.icon_url == another.icon_url && self.release_date.to_i == another.release_date.to_i && self.price == another.price
  end
  
end