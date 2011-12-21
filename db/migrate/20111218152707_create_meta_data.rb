class CreateMetaData < ActiveRecord::Migration
  def change
    create_table :meta_data do |t|
      t.column :name, :string
      t.column :summary, :text
      t.string :icon
      
      t.boolean :new_version
      
      t.decimal :price, :precision => 5, :scale => 2
      
      t.belongs_to :game
      t.timestamps
    end
  end
end
