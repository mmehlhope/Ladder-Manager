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

ActiveRecord::Schema.define(version: 20140624150043) do

  create_table "competitors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ladder_id"
    t.integer  "rating",     default: 1000
    t.integer  "wins",       default: 0
    t.integer  "draws",      default: 0
  end

  add_index "competitors", ["ladder_id"], name: "index_competitors_on_ladder_id", using: :btree

  create_table "competitors_games", id: false, force: true do |t|
    t.integer "game_id"
    t.integer "competitor_id"
  end

  create_table "competitors_matches", id: false, force: true do |t|
    t.integer "match_id"
    t.integer "competitor_id"
  end

  add_index "competitors_matches", ["competitor_id"], name: "index_competitors_matches_on_competitor_id", using: :btree
  add_index "competitors_matches", ["match_id", "competitor_id"], name: "index_competitors_matches_on_match_id_and_competitor_id", using: :btree

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "match_id"
    t.integer  "winner_id"
    t.integer  "competitor_1_score"
    t.integer  "competitor_2_score"
    t.integer  "ladder_id"
  end

  add_index "games", ["match_id"], name: "index_games_on_match_id", using: :btree

  create_table "ladders", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "organization_id"
  end

  add_index "ladders", ["organization_id"], name: "index_ladders_on_organization_id", using: :btree
  add_index "ladders", ["user_id"], name: "index_ladders_on_user_id", using: :btree

  create_table "matches", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ladder_id"
    t.integer  "competitor_1"
    t.integer  "competitor_2"
    t.integer  "winner_id"
    t.boolean  "finalized",    default: false
  end

  add_index "matches", ["competitor_1"], name: "index_matches_on_competitor_1", using: :btree
  add_index "matches", ["competitor_2"], name: "index_matches_on_competitor_2", using: :btree
  add_index "matches", ["ladder_id"], name: "index_matches_on_ladder_id", using: :btree

  create_table "organizations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
