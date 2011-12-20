class AddMissingIndexes < ActiveRecord::Migration
  def up
    add_index :games, :itunes_id
    
    add_index :meta_data, :game_id
    add_index :meta_data, :itunes_id
    
    add_index :game_snapshots, :meta_data_id
    add_index :game_snapshots, :game_id
    add_index :game_snapshots, :chart_snapshot_id
    
    add_index :chart_snapshots, :import_id
    add_index :chart_snapshots, :chart_id
  end

  def down
    remove_index :games, :itunes_id

    remove_index :meta_data, :game_id
    remove_index :meta_data, :itunes_id

    remove_index :game_snapshots, :meta_data_id
    remove_index :game_snapshots, :game_id
    remove_index :game_snapshots, :chart_snapshot_id

    remove_index :chart_snapshots, :import_id
    remove_index :chart_snapshots, :chart_id
  end
end
