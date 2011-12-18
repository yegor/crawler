class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.datetime :release_date
      
      t.timestamps
    end
  end
end
