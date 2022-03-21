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

ActiveRecord::Schema.define(version: 2016_03_23_201608) do

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "quantity"
    t.string "barcode"
    t.string "barcode_data"
    t.string "barcode_img_file_name"
    t.string "barcode_img_content_type"
    t.bigint "barcode_img_file_size"
    t.datetime "barcode_img_updated_at"
    t.integer "category"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "item_id"
    t.integer "user_id"
    t.integer "count"
    t.integer "brought_back"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "status", default: 1
    t.text "disapproval_message"
    t.integer "picked_up_count", default: 0
    t.integer "brought_back_count", default: 0
    t.index ["item_id"], name: "index_reservations_on_item_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email"
    t.datetime "deadline"
    t.string "event_name"
    t.string "organisation_name", default: "", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "authentication_token"
    t.string "role", default: "partner"
    t.string "name"
    t.boolean "sent", default: true
    t.string "barcode"
    t.string "barcode_data"
    t.string "barcode_img_file_name"
    t.string "barcode_img_content_type"
    t.bigint "barcode_img_file_size"
    t.datetime "barcode_img_updated_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
