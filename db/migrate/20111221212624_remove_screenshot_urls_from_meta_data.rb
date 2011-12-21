class RemoveScreenshotUrlsFromMetaData < ActiveRecord::Migration
  def up
    remove_column :meta_data, :screenshot_url
    remove_column :meta_data, :icon_url
  end

  def down
    add_column :meta_data, :screenshot_url, :string
    add_column :meta_data, :icon_url, :string
  end
end
