class CreateFeaturings < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, :null => false
      t.string :uid, :null => false
      
      t.column :store, "ENUM('iphone', 'ipad')", :null => false
      t.column :type, "ENUM('Featuring::Page::Main', 'Featuring::Page::Category', 'Featuring::Page::Room')", :null => false
      
      t.timestamps
    end
    
    create_table :featurings do |t|
      t.column :type, "ENUM('Featuring::Feature::Super', 'Featuring::Feature::Brick', 'Featuring::Feature::Item')"
      t.integer :rank, :null => false
    
      t.belongs_to :page, :null => false
      
      t.timestamps
    end
    
    create_table :featurings_game_snapshots, :id => false do |t|
      t.belongs_to :featuring, :null => false
      t.belongs_to :game_snapshot, :null => false
    end
    
    add_index :pages, [:store, :uid], :unique => true
    add_index :featurings, [:type, :page_id, :rank], :unique => true
    add_index :featurings_game_snapshots, [:featuring_id, :game_snapshot_id], :name => "idx_featurings_game_snapshots", :unique => true
  end
end
