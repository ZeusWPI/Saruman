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

ActiveRecord::Schema[7.0].define(version: 2023_04_23_181347) do
  create_table "items", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "quantity"
    t.string "barcode"
    t.string "barcode_data"
    t.string "barcode_img_file_name"
    t.string "barcode_img_content_type"
    t.bigint "barcode_img_file_size"
    t.datetime "barcode_img_updated_at", precision: nil
    t.integer "category"
    t.integer "deposit", default: 0
  end

  create_table "reservations", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.integer "item_id"
    t.integer "user_id"
    t.integer "count"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "status", default: 1
    t.text "disapproval_message"
    t.integer "picked_up_count", default: 0
    t.integer "returned_unused_count", default: 0
    t.integer "returned_used_count", default: 0
    t.index ["item_id"], name: "index_reservations_on_item_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "settings", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "email"
    t.datetime "deadline", precision: nil
    t.string "event_name"
    t.string "organisation_name", default: "", null: false
  end

  create_table "users", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "authentication_token"
    t.string "role", default: "partner"
    t.string "name"
    t.boolean "sent", default: true
    t.string "barcode"
    t.string "barcode_data"
    t.string "barcode_img_file_name"
    t.string "barcode_img_content_type"
    t.bigint "barcode_img_file_size"
    t.datetime "barcode_img_updated_at", precision: nil
    t.index ["authentication_token"], name: "index_users_on_authentication_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :integer, charset: "latin1", collation: "latin1_swedish_ci", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
