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

ActiveRecord::Schema.define(:version => 20140304004044) do

  create_table "batting_stats", :force => true do |t|
    t.integer  "player_id"
    t.string   "team"
    t.integer  "year"
    t.integer  "at_bats"
    t.integer  "hits"
    t.integer  "doubles"
    t.integer  "singles"
    t.integer  "home_runs"
    t.integer  "runs_batted_in"
    t.integer  "stolen_bases"
    t.integer  "caught_stealing"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "batting_stats", ["player_id", "team", "year"], :name => "index_batting_stats_on_player_id_and_team_and_year", :unique => true
  add_index "batting_stats", ["player_id"], :name => "index_batting_stats_on_player_id"

  create_table "players", :force => true do |t|
    t.string   "player_legacy_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "birth_year"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "players", ["player_legacy_id"], :name => "index_players_on_player_legacy_id", :unique => true

end
