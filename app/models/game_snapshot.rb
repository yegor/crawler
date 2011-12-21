class GameSnapshot < ActiveRecord::Base
  belongs_to :game
  belongs_to :meta_data
  belongs_to :chart_snapshot
  
  validates_presence_of :rank
  validates_presence_of :game
  validates_presence_of :meta_data
  validates_presence_of :chart_snapshot
  validates_presence_of :itunes_id
  
  before_validation :set_itunes_id
  
  scope :not_yet_sexy, where(:appstore_syncronized => false)
  
  #  Update required attributes with AppStore Lookup entry
  #
  #  * <tt>entry</tt>:: +AppStore::LookupEntry+ lookup entry
  #
  def update_with_entry(entry)
    self.meta_data.smart_update_attributes entry.instance_values.symbolize_keys
    self.smart_update_attributes entry.instance_values.symbolize_keys
  end
  
  private
  
  def set_itunes_id
    self.itunes_id = game.itunes_id
  end
end
