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

ActiveRecord::Schema.define(version: 20141030234629) do

  create_table "blackjacks", force: true do |t|
    t.integer  "user_id"
    t.text     "user_hand"
    t.text     "dealer_hand"
    t.text     "deck"
    t.integer  "game_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blackjacks", ["user_id"], name: "index_blackjacks_on_user_id", using: :btree

  create_table "user_stats", force: true do |t|
    t.integer  "user_id"
    t.integer  "wins",       default: 0, null: false
    t.integer  "losses",     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_stats", ["user_id"], name: "index_user_stats_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",          null: false
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["name"], name: "index_users_on_name", using: :btree

end
