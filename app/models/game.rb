# == Schema Information
#
# Table name: games
#
#  id           :integer(4)      not null, primary key
#  release_date :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  itunes_id    :integer(8)
#
# Indexes
#
#  index_games_on_itunes_id  (itunes_id)
#

class Game < ActiveRecord::Base
  has_many :game_snapshots
  has_many :meta_datas, :class_name => "MetaData"
  has_one  :meta_data, :order => "meta_data.id DESC"
  has_one  :first_meta_data, :class_name => "MetaData", :order => "meta_data.id ASC"
  
  validates_presence_of :itunes_id
  
  class << self
    
    def find_or_create_from_appstore(opt = {})
      game = Game.find_or_initialize_by_itunes_id opt[:entry].itunes_id
      game.release_date = opt[:entry].release_date if game.new_record?
      game.save
      
      game
    end
    
    def bulk_create(entries)
      sql = "INSERT IGNORE INTO games (release_date, created_at, updated_at, itunes_id) VALUES "
      
      entries.keys.sort.each do |itunes_id|
        entry = entries[itunes_id]
        sql << " ( #{ [ entry.release_date, Time.now, Time.now, itunes_id ].map { |v| connection.quote(v) }.join(", ") } ),"
      end
      
      connection.execute(sql.chop)
      
      where(:itunes_id => entries.keys).all
    end
    
  end
end

