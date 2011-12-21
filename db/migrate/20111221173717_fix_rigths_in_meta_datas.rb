class FixRigthsInMetaDatas < ActiveRecord::Migration
  def up
    change_column :meta_data, :rights, :text
  end

  def down
    change_column :meta_data, :rights, :string
  end
end
