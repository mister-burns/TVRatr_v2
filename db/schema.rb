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

ActiveRecord::Schema.define(version: 20131221053724) do

  create_table "genres", force: true do |t|
    t.string   "genre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_attribute_types", force: true do |t|
    t.string   "genre"
    t.string   "format"
    t.string   "network"
    t.string   "language"
    t.string   "country"
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
    t.string   "genre_1"
    t.string   "genre_2"
    t.string   "genre_3"
    t.string   "genre_4"
    t.string   "genre_5"
    t.string   "format_1"
    t.string   "format_2"
    t.string   "format_3"
    t.string   "format_4"
    t.string   "format_5"
    t.string   "country_1"
    t.string   "country_2"
    t.string   "country_3"
    t.string   "network_1"
    t.string   "network_2"
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
  end

  create_table "wikipedia_api_queries", force: true do |t|
    t.integer  "wikipedia_page_id"
    t.string   "show_name"
    t.text     "infobox"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
