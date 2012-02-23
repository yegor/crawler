class ConvertIdsToBigint < ActiveRecord::Migration
  def change
    change_table :meta_data do |t|
      t.string :itunes_artwork_icon_url, :null => false, :default => ''
    end
    
    [MetaData, Chart, ChartSnapshot, Featuring::Feature::Base, Featuring::Page::Base, Game, GameSnapshot, Import].each do |model|
      change_table model.table_name do |t|
        model.columns.select { |col| col.name =~ /(^id$)|(_id$)/ }.each do |column|
          #p [column.name, "BIGINT(20)", :null => column.null, :default => column.default, :primary => column.primary]
          t.change column.name, "BIGINT(20)", :null => column.null, :default => column.default, :primary => column.primary
        end
      end
    end
  end
end
