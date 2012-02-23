class FixPrimaryKeys < ActiveRecord::Migration
  def change
    [MetaData, Chart, ChartSnapshot, Featuring::Feature::Base, Featuring::Page::Base, Game, GameSnapshot, Import].each do |model|
      connection.execute "ALTER TABLE #{ model.table_name } MODIFY id BIGINT(20) NOT NULL AUTO_INCREMENT"
    end
  end
end
