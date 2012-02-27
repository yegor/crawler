class AddMissingFeaturingIndex < ActiveRecord::Migration
  def change
    connection.execute "ALTER IGNORE TABLE featuring_snapshots ADD UNIQUE INDEX idx_featuring_snapshots_main (import_id, country, itunes_id, featuring_id)"
  end
end
