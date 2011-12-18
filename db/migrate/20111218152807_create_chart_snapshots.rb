class CreateChartSnapshots < ActiveRecord::Migration
  def change
    create_table :chart_snapshots do |t|
      t.belongs_to :import
      t.belongs_to :chart
      
      t.timestamps
    end
  end
end
