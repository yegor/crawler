# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120220202435) do

  create_table "chart_snapshots", :force => true do |t|
    t.integer  "import_id"
    t.integer  "chart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chart_snapshots", ["chart_id"], :name => "index_chart_snapshots_on_chart_id"
  add_index "chart_snapshots", ["import_id"], :name => "index_chart_snapshots_on_import_id"

  create_table "charts", :force => true do |t|
    t.string   "country"
    t.integer  "limit"
    t.string   "kind"
    t.string   "genre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featurings", :force => true do |t|
    t.string   "type",       :limit => 0
    t.integer  "rank",                    :null => false
    t.integer  "page_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "featurings", ["type", "page_id", "rank"], :name => "index_featurings_on_type_and_page_id_and_rank", :unique => true

  create_table "featurings_game_snapshots", :id => false, :force => true do |t|
    t.integer "featuring_id",     :null => false
    t.integer "game_snapshot_id", :null => false
  end

  add_index "featurings_game_snapshots", ["featuring_id", "game_snapshot_id"], :name => "idx_featurings_game_snapshots", :unique => true
  add_index "featurings_game_snapshots", ["game_snapshot_id", "featuring_id"], :name => "idx_featurings_game_snapshots2", :unique => true

  create_table "game_snapshots", :force => true do |t|
    t.integer  "rank"
    t.float    "rating"
    t.integer  "game_id"
    t.integer  "meta_data_id"
    t.integer  "chart_snapshot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "average_user_rating_for_current_version",              :precision => 2, :scale => 1
    t.integer  "user_rating_count_for_current_version"
    t.decimal  "average_user_rating_for_all_versions",                 :precision => 2, :scale => 1
    t.integer  "user_rating_count_for_all_versions"
    t.boolean  "appstore_syncronized",                                                               :default => false
    t.decimal  "price",                                                :precision => 5, :scale => 2
    t.string   "currency"
    t.integer  "itunes_id",                               :limit => 8
  end

  add_index "game_snapshots", ["appstore_syncronized"], :name => "index_game_snapshots_on_appstore_syncronized"
  add_index "game_snapshots", ["chart_snapshot_id"], :name => "index_game_snapshots_on_chart_snapshot_id"
  add_index "game_snapshots", ["game_id"], :name => "index_game_snapshots_on_game_id"
  add_index "game_snapshots", ["meta_data_id"], :name => "index_game_snapshots_on_meta_data_id"

  create_table "games", :force => true do |t|
    t.datetime "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "itunes_id",    :limit => 8
  end

  add_index "games", ["itunes_id"], :name => "index_games_on_itunes_id", :unique => true

  create_table "imports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_data", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.boolean  "new_version",                      :default => false
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publisher"
    t.text     "rights"
    t.datetime "release_date"
    t.integer  "file_size_bytes"
    t.string   "itunes_artwork_url"
    t.integer  "itunes_id",           :limit => 8
    t.string   "release_notes"
    t.boolean  "game_center_enabled"
    t.string   "genres"
    t.string   "screenshots"
    t.string   "version"
    t.string   "hashcode",                         :default => "",    :null => false
  end

  add_index "meta_data", ["game_id", "hashcode"], :name => "index_meta_data_on_game_id_and_hashcode", :unique => true
  add_index "meta_data", ["game_id"], :name => "index_meta_data_on_game_id"
  add_index "meta_data", ["itunes_id"], :name => "index_meta_data_on_itunes_id"

  create_table "pages", :force => true do |t|
    t.string   "title",                   :null => false
    t.string   "uid",                     :null => false
    t.string   "store",      :limit => 0, :null => false
    t.string   "type",       :limit => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["store", "uid"], :name => "index_pages_on_store_and_uid", :unique => true

end
