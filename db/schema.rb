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

ActiveRecord::Schema.define(version: 20140120231150) do

  create_table "actor_shows", force: true do |t|
    t.integer  "actor_id"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "country_shows", force: true do |t|
    t.integer  "country_id"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genre_shows", force: true do |t|
    t.integer  "genre_id"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "network_shows", force: true do |t|
    t.integer  "network_id"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", force: true do |t|
    t.integer  "wikipedia_page_id"
    t.string   "show_name"
    t.datetime "first_aired"
    t.datetime "last_aired"
    t.boolean  "show_active"
    t.integer  "number_of_episodes"
    t.integer  "number_of_seasons"
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "serialized"
    t.integer  "number_of_series"
    t.string   "last_aired_present"
    t.string   "first_aired_string"
    t.string   "last_aired_string"
    t.float    "imdb_rating"
    t.float    "tv_dot_com_rating"
    t.integer  "imdb_rating_count"
    t.integer  "tv_dot_com_rating_count"
    t.integer  "metacritic_rating_count"
    t.string   "imdb_link"
    t.string   "tv_dot_com_link"
    t.text     "metacritic_rating"
    t.string   "metacritic_link"
    t.float    "metacritic_average_rating"
    t.text     "amazon_instant_availability"
    t.text     "amazon_own_availability"
    t.text     "itunes_link"
  end

  create_table "wikipedia_api_queries", force: true do |t|
    t.integer  "wikipedia_page_id"
    t.string   "show_name"
    t.text     "infobox"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
