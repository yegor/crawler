class MoreSexyFieldsToMetaData < ActiveRecord::Migration
  def up
    add_column :meta_data, :average_user_rating_for_current_version, :decimal, :precision => 2, :scale => 1
    add_column :meta_data, :user_rating_count_for_current_version, :integer
    add_column :meta_data, :average_user_rating_for_all_versions, :decimal, :precision => 2, :scale => 1
    add_column :meta_data, :user_rating_count_for_all_versions, :integer
    add_column :meta_data, :file_size_bytes, :integer
    
    add_column :meta_data, :itunes_artwork_url, :string
    add_column :meta_data, :itunes_id, 'BIGINT(20)'
    
    add_column :meta_data, :release_notes, :string
    
    add_column :meta_data, :game_center_enabled, :boolean
    
    add_column :meta_data, :genres, :string
    add_column :meta_data, :screenshots, :string
    
    change_column :meta_data, :summary, :text
    
    add_column :meta_data, :version, :string
    
    add_column :meta_data, :appstore_syncronized, :boolean, :default => false
  end

  def down
    remove_column :meta_data, :average_user_rating_for_current_version
    remove_column :meta_data, :user_rating_count_for_current_version
    remove_column :meta_data, :average_user_rating_for_all_versions
    remove_column :meta_data, :user_rating_count_for_all_versions
    remove_column :meta_data, :file_size_bytes
    
    remove_column :meta_data, :itunes_artwork_url
    remove_column :meta_data, :itunes_id
    
    remove_column :meta_data, :release_notes
    
    remove_column :meta_data, :game_center_enabled
    
    remove_column :meta_data, :genres
    remove_column :meta_data, :screenshots

    change_column :meta_data, :summary, :string
    
    remove_column :meta_data, :version
    
    remove_column :meta_data, :appstore_syncronized
  end
end