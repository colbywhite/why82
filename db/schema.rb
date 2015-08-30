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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150830005722) do

  create_table "games", force: :cascade do |t|
    t.datetime "time"
    t.integer  "home_id"
    t.integer  "away_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "games", ["away_id"], name: "index_games_on_away_id"
  add_index "games", ["home_id"], name: "index_games_on_home_id"

  create_table "seed_migration_data_migrations", force: :cascade do |t|
    t.string   "version"
    t.integer  "runtime"
    t.datetime "migrated_on"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.string   "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["abbr"], name: "index_teams_on_abbr"
  add_index "teams", ["logo"], name: "index_teams_on_logo"
  add_index "teams", ["name"], name: "index_teams_on_name"

end
