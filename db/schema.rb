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

ActiveRecord::Schema.define(version: 20160303212948) do

  create_table "items", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.string   "description",              limit: 255
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.string   "barcode",                  limit: 255
    t.string   "barcode_data",             limit: 255
    t.string   "barcode_img_file_name"
    t.string   "barcode_img_content_type"
    t.integer  "barcode_img_file_size"
    t.datetime "barcode_img_updated_at"
    t.integer  "category"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.integer  "count"
    t.integer  "fetched"
    t.integer  "brought_back"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",              default: 1
    t.text     "disapproval_message"
    t.integer  "picked_up_count",     default: 0
    t.integer  "brought_back_count",  default: 0
  end

  add_index "reservations", ["item_id"], name: "index_reservations_on_item_id"
  add_index "reservations", ["user_id"], name: "index_reservations_on_user_id"

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",      limit: 255
    t.datetime "deadline"
    t.string   "name",       limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    limit: 255, default: "",        null: false
    t.string   "encrypted_password",       limit: 255, default: "",        null: false
    t.string   "reset_password_token",     limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",       limit: 255
    t.string   "last_sign_in_ip",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token",     limit: 255
    t.string   "role",                     limit: 255, default: "partner"
    t.string   "name",                     limit: 255
    t.boolean  "sent",                                 default: true
    t.string   "barcode",                  limit: 255
    t.string   "barcode_data",             limit: 255
    t.string   "barcode_img_file_name"
    t.string   "barcode_img_content_type"
    t.integer  "barcode_img_file_size"
    t.datetime "barcode_img_updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      limit: 255, null: false
    t.integer  "item_id",                    null: false
    t.string   "event",          limit: 255, null: false
    t.string   "whodunnit",      limit: 255
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
