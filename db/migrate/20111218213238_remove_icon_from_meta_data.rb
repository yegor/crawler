class RemoveIconFromMetaData < ActiveRecord::Migration
  def up
    remove_column :meta_data, :icon
    change_column :meta_data, :new_version, :boolean, :default => false
  end

  def down
    change_column :meta_data, :new_version, :boolean
    add_column :meta_data, :icon, :string
  end
end
