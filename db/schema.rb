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

ActiveRecord::Schema.define(version: 20240502075304) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scheduled_end_time"
    t.string "business_outline"
    t.string "instructor_test"
    t.boolean "tomorrow", default: false
    t.integer "instructor_reply"
    t.boolean "change", default: false
    t.string "instructor_one_month_test"
    t.integer "instructor_one_month_reply"
    t.boolean "change_one_month", default: false
    t.boolean "tomorrow_one_month", default: false
    t.string "instructor_comp_test"
    t.boolean "change_comp", default: false
    t.integer "instructor_comp_reply"
    t.datetime "before_started_at"
    t.datetime "before_finished_at"
    t.date "reply_updated_at"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "monthly_states", force: :cascade do |t|
    t.date "worked_in"
    t.string "request_instructor"
    t.integer "instructor_reply"
    t.boolean "change", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_monthly_states_on_user_id"
  end

  create_table "places", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "working_style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.boolean "admin"
    t.string "affiliation"
    t.datetime "basic_work_time", default: "2024-05-02 23:00:00"
    t.datetime "work_time", default: "2024-05-02 22:30:00"
    t.boolean "superior", default: false
    t.datetime "designated_work_start_time", default: "2024-05-03 00:00:00"
    t.datetime "designated_work_end_time", default: "2024-05-03 09:00:00"
    t.integer "employee_number"
    t.string "uid"
  end

end
