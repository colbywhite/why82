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

ActiveRecord::Schema.define(version: 20151024024241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "time"
    t.integer  "away_id"
    t.integer  "home_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "home_score"
    t.integer  "away_score"
    t.integer  "season_id",  null: false
  end

  add_index "games", ["away_id"], name: "index_games_on_away_id", using: :btree
  add_index "games", ["home_id"], name: "index_games_on_home_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seed_migration_data_migrations", force: :cascade do |t|
    t.string   "version"
    t.integer  "runtime"
    t.datetime "migrated_on"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "season_id",  null: false
  end

  add_index "teams", ["abbr"], name: "index_teams_on_abbr", using: :btree
  add_index "teams", ["name"], name: "index_teams_on_name", using: :btree

  add_foreign_key "games", "seasons"
  add_foreign_key "games", "teams", column: "away_id"
  add_foreign_key "games", "teams", column: "home_id"
  add_foreign_key "teams", "seasons"
end
