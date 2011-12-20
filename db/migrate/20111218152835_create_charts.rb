class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.string :country
      t.integer :limit
      t.string :kind#, "ENUM(#{Chart::KINDS.collect{|kind| "'#{kind.to_s}'"}.join(', ')})"
      t.string :genre#, "ENUM(#{Chart::GENRES.keys.collect{|genre| "'#{genre.to_s}'"}.join(', ')})"
      
      t.timestamps
    end
  end
end
