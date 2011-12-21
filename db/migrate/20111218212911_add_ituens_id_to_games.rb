class AddItuensIdToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :itunes_id, 'BIGINT(20)'
  end
  
  def self.down
    remove_column :games, :itunes_id
  end
end