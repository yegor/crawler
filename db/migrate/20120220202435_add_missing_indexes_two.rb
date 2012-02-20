class AddMissingIndexesTwo < ActiveRecord::Migration
  
  def change
    add_index :featurings_game_snapshots, [:game_snapshot_id, :featuring_id], :name => "idx_featurings_game_snapshots2", :unique => true
  end

end
