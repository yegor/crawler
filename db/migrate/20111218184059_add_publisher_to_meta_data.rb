class AddPublisherToMetaData < ActiveRecord::Migration
  def self.up
    add_column :meta_data, :publisher, :string
    add_column :meta_data, :rights, :string
    add_column :meta_data, :screenshot_url, :string
    add_column :meta_data, :icon_url, :string
    add_column :meta_data, :release_date, :datetime
  end
  
  def self.down
    remove_column :meta_data, :release_date
    remove_column :meta_data, :icon_url
    remove_column :meta_data, :screenshot_url
    remove_column :meta_data, :rights
    remove_column :meta_data, :publisher
  end
end