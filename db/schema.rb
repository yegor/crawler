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

ActiveRecord::Schema.define(:version => 20111218152835) do

  create_table "chart_snapshots", :force => true do |t|
    t.integer  "import_id"
    t.integer  "chart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charts", :force => true do |t|
    t.string   "country"
    t.string   "kind",       :limit => 0
    t.string   "genre",      :limit => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_snapshots", :force => true do |t|
    t.integer  "rank"
    t.float    "rating"
    t.integer  "game_id"
    t.integer  "meta_data_id"
    t.integer  "chart_snapshot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.datetime "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta_data", :force => true do |t|
    t.string   "name"
    t.string   "summary"
    t.string   "icon"
    t.boolean  "new_version"
    t.decimal  "price",       :precision => 5, :scale => 2
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
