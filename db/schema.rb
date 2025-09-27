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

ActiveRecord::Schema[7.2].define(version: 2025_09_27_062209) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "daily_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "recorded_on", null: false
    t.float "weight"
    t.float "body_fat_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "recorded_on"], name: "index_daily_records_on_user_id_and_recorded_on", unique: true
    t.index ["user_id"], name: "index_daily_records_on_user_id"
  end

  create_table "habit_checks", force: :cascade do |t|
    t.bigint "daily_record_id", null: false
    t.bigint "habit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "done", default: false, null: false
    t.index ["daily_record_id", "habit_id"], name: "index_habit_checks_on_daily_record_id_and_habit_id", unique: true
    t.index ["daily_record_id"], name: "index_habit_checks_on_daily_record_id"
    t.index ["habit_id"], name: "index_habit_checks_on_habit_id"
  end

  create_table "habits", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "difficulty", default: 0, null: false
    t.date "started_on"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_habits_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.float "start_weight"
    t.float "start_body_fat_percentage"
    t.float "goal_weight"
    t.float "goal_body_fat_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "onboarding_completed_at"
    t.string "username", default: ""
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "daily_records", "users"
  add_foreign_key "habit_checks", "daily_records", on_delete: :cascade
  add_foreign_key "habit_checks", "habits", on_delete: :cascade
  add_foreign_key "habits", "users"
end
