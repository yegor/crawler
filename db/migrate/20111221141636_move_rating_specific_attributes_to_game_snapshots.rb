class MoveRatingSpecificAttributesToGameSnapshots < ActiveRecord::Migration
  def up
    remove_column :meta_data, :average_user_rating_for_current_version
    remove_column :meta_data, :user_rating_count_for_current_version
    remove_column :meta_data, :average_user_rating_for_all_versions
    remove_column :meta_data, :user_rating_count_for_all_versions
    remove_column :meta_data, :appstore_syncronized
    remove_column :meta_data, :price
    
    add_column :game_snapshots, :average_user_rating_for_current_version, :decimal, :precision => 2, :scale => 1
    add_column :game_snapshots, :user_rating_count_for_current_version, :integer
    add_column :game_snapshots, :average_user_rating_for_all_versions, :decimal, :precision => 2, :scale => 1
    add_column :game_snapshots, :user_rating_count_for_all_versions, :integer
    add_column :game_snapshots, :appstore_syncronized, :boolean, :default => false
    add_column :game_snapshots, :price, :decimal, :precision => 5, :scale => 2
    add_column :game_snapshots, :currency, :string
    add_column :game_snapshots, :itunes_id, 'BIGINT(20)'
    
    add_index :game_snapshots, :appstore_syncronized
  end

  def down
    add_column :meta_data, :average_user_rating_for_current_version, :decimal, :precision => 2, :scale => 1
    add_column :meta_data, :user_rating_count_for_current_version, :integer
    add_column :meta_data, :average_user_rating_for_all_versions, :decimal, :precision => 2, :scale => 1
    add_column :meta_data, :user_rating_count_for_all_versions, :integer
    add_column :meta_data, :appstore_syncronized, :boolean, :default => false
    add_column :meta_data, :price, :decimal, :precision => 5, :scale => 2
    
    remove_column :game_snapshots, :average_user_rating_for_current_version
    remove_column :game_snapshots, :user_rating_count_for_current_version
    remove_column :game_snapshots, :average_user_rating_for_all_versions
    remove_column :game_snapshots, :user_rating_count_for_all_versions
    remove_column :game_snapshots, :appstore_syncronized
    remove_column :game_snapshots, :price
    remove_column :game_snapshots, :currency
    remove_column :game_snapshots, :itunes_id
  end
end