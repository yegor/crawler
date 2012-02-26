class CreateFeaturingSnapshots < ActiveRecord::Migration
  def change
    create_table :featuring_snapshots do |t|
      t.column :itunes_id, "BIGINT(20)", :null => false
      t.string :country, :null => false
      
      t.belongs_to :import, :null => false
      t.belongs_to :featuring, :null => false
    end
    
    add_index :featuring_snapshots, :itunes_id
    add_index :featuring_snapshots, :import_id
    add_index :featuring_snapshots, :featuring_id
  end
end
