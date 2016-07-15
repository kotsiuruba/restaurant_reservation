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

ActiveRecord::Schema.define(version: 20160715125459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "reservations", force: :cascade do |t|
    t.integer  "table_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.index ["table_id"], name: "index_reservations_on_table_id", using: :btree
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "title"
    t.time   "open_at"
    t.time   "close_at"
  end

  create_table "tables", force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "number"
    t.index ["restaurant_id", "number"], name: "restaurant_table_number_index", unique: true, using: :btree
    t.index ["restaurant_id"], name: "index_tables_on_restaurant_id", using: :btree
  end

  add_foreign_key "reservations", "tables"
  add_foreign_key "tables", "restaurants"
end
