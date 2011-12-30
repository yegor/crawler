class SetupIndecies < ActiveRecord::Migration
  def up
    remove_index :games, :itunes_id
    add_index :games, :itunes_id, :unique => true
    
    change_table :meta_data do |t|
      t.string :hashcode, :null => false, :default => ""
    end
    
    MetaData.find_in_batches(:batch_size => 1000) do |metas|
      MetaData.transaction do 
        metas.each do |meta|
          meta.ensure_hashcode!
          meta.save
        end
      end
    end
    
    add_index :meta_data, [:game_id, :hashcode], :unique => true
  end

  def down
    remove_index :games, :itunes_id
    add_index :games, :itunes_id
  end
end
