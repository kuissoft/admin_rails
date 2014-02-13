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

ActiveRecord::Schema.define(version: 20140213125924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.boolean  "is_pending",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_rejected", default: false
    t.string   "nickname"
    t.boolean  "is_removed",  default: false
  end

  create_table "devices", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.text     "message"
    t.string   "feedback_type"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.integer  "session_id"
    t.float    "lat"
    t.float    "lon"
    t.integer  "bearing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["session_id"], name: "index_locations_on_session_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "notification_type"
    t.integer  "user_id"
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_user_id"
  end

  create_table "rapns_apps", force: true do |t|
    t.string   "name",                    null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections", default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                    null: false
    t.string   "auth_key"
  end

  create_table "rapns_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app"
  end

  add_index "rapns_feedback", ["device_token"], name: "index_rapns_feedback_on_device_token", using: :btree

  create_table "rapns_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                default: false
    t.string   "type",                                             null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                           null: false
    t.integer  "retries",                      default: 0
  end

  add_index "rapns_notifications", ["app_id", "delivered", "failed", "deliver_after"], name: "index_rapns_notifications_multi", using: :btree

  create_table "settings", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "value"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "role",                            default: "user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",              default: "",     null: false
    t.string   "auth_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "last_token"
    t.datetime "token_updated_at"
    t.string   "validation_code"
    t.integer  "verification_code_sent_count",    default: 0
    t.integer  "verification_code_invalid_count", default: 0
    t.boolean  "is_online",                       default: false
    t.string   "connection_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
