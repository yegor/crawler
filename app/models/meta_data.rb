require "iconv"
require "digest/sha2"

class MetaData < ActiveRecord::Base
  serialize :genres, Array
  serialize :screenshots, Array
  
  belongs_to :game
  
  validates_presence_of :name
  validates_presence_of :summary
  validates_presence_of :publisher
  validates_presence_of :release_date
  validates_presence_of :itunes_id
  
  before_save :ensure_hashcode!
  
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
    
    def bulk_create(games, entries)
      columns = self.new.send(:arel_attributes_values).keys.map(&:name)
      
      sql = "INSERT IGNORE INTO meta_data ( #{columns.join ", "} ) VALUES "
      metas = games.sort_by(&:id).map do |game|
        meta = self.new( :created_at => Time.now, :updated_at => Time.now, :game_id => game.id, :new_version => true )
        
        meta.smart_assign_attributes( entries[ game.itunes_id ].instance_values )
        meta.smart_assign_attributes( entries[ game.itunes_id ].lookup_entry.instance_values )
        
        meta.ensure_hashcode!
        
        vals = [0] + meta.send(:arel_attributes_values).values[1..-1]
        sql << "( #{ vals.map { |v| connection.quote(v) }.join ", " } ),"
        
        meta
      end
      
      connection.execute(sql.chop)
      where(:game_id => metas.map(&:game_id), :hashcode => metas.map(&:hashcode)).all.tap do |created_or_updated_metas|
        ids = created_or_updated_metas.map(&:id)
        non_versions = MetaData.joins("INNER JOIN meta_data m ON m.game_id = meta_data.game_id AND m.release_date = meta_data.release_date AND m.id < meta_data.id").where(:id => ids).select("meta_data.id").map(&:id)
        MetaData.where(:id => non_versions).update_all(:new_version => false)
      end
    end
  end
  
  def ensure_hashcode!
    self.hashcode = Digest::SHA2.hexdigest("#{self.name}-#{self.summary}-#{self.rights}-#{self.publisher}-#{self.release_date}")
  end
  
  def ==(another)
    self.name == another.name && self.summary == another.summary && self.rights == another.rights && self.publisher == another.publisher && self.release_date.to_i == another.release_date.to_i
  end
  
  def summary=(value)
    write_attribute :summary, value.gsub(/[^\u0000-\uFFFF]/, '')
  end
  
  def rights=(value)
    write_attribute :rights, value.gsub(/[^\u0000-\uFFFF]/, '')
  end
  
  def name=(value)
    write_attribute :name, value.gsub(/[^\u0000-\uFFFF]/, '')
  end
  
  private
  
end