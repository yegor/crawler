class Game < ActiveRecord::Base
  has_many :game_snapshots
  has_many :meta_datas, :class_name => "MetaData"
  
  validates_presence_of :itunes_id
  
  class << self
    
    def find_or_create_from_appstore(opt = {})
      game = Game.find_or_initialize_by_itunes_id opt[:entry].itunes_id
      game.release_date = opt[:entry].release_date if game.new_record?
      game.save
      
      game
    end
    
  end
end
