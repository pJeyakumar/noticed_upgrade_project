# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_06_04_142554) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aircrafts", force: :cascade do |t|
    t.string "make"
    t.string "model"
    t.integer "engine"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logbook_entries", force: :cascade do |t|
    t.bigint "aircraft_id"
    t.datetime "date"
    t.string "departure_icao"
    t.string "arrival_icao"
    t.float "duration"
    t.bigint "pilot_in_command_id"
    t.bigint "second_in_command_id"
    t.float "flt_training"
    t.float "ground_training"
    t.float "simulator"
    t.float "cross_country"
    t.integer "time_of_day"
    t.float "actual_instrument"
    t.float "simulated_instrument"
    t.integer "day_landing"
    t.integer "night_landing"
    t.integer "single_engine_land"
    t.integer "multi_engine_land"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aircraft_id"], name: "index_logbook_entries_on_aircraft_id"
    t.index ["pilot_in_command_id"], name: "index_logbook_entries_on_pilot_in_command_id"
    t.index ["second_in_command_id"], name: "index_logbook_entries_on_second_in_command_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "title"
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "logbook_entries", "aircrafts"
  add_foreign_key "logbook_entries", "users", column: "pilot_in_command_id"
  add_foreign_key "logbook_entries", "users", column: "second_in_command_id"
end
