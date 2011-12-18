class CreateGameSnapshots < ActiveRecord::Migration
  def change
    create_table :game_snapshots do |t|
      t.integer :rank
      t.float :rating
      
      t.belongs_to :game
      t.belongs_to :meta_data
      t.belongs_to :chart_snapshot
      t.timestamps
    end
  end
end