class InitSchema < ActiveRecord::Migration[7.0]
  def up
    create_table "active_storage_attachments", force: :cascade do |t|
      t.string "name", null: false
      t.string "record_type", null: false
      t.bigint "record_id", null: false
      t.bigint "blob_id", null: false
      t.datetime "created_at", null: false
      t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
      t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    end

    create_table "active_storage_blobs", force: :cascade do |t|
      t.string "key", null: false
      t.string "filename", null: false
      t.string "content_type"
      t.text "metadata"
      t.string "service_name", null: false
      t.bigint "byte_size", null: false
      t.string "checksum"
      t.datetime "created_at", null: false
      t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    end

    create_table "active_storage_variant_records", force: :cascade do |t|
      t.bigint "blob_id", null: false
      t.string "variation_digest", null: false
      t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    end

    create_table "items", id: :serial, force: :cascade do |t|
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

    create_table "partners", id: :serial, force: :cascade do |t|
      t.string "name"
      t.string "barcode_data"
      t.string "email"
      t.datetime "created_at", precision: nil
      t.datetime "updated_at", precision: nil
      t.string "encrypted_password", default: "", null: false
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at", precision: nil
      t.datetime "remember_created_at", precision: nil
      t.integer "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at", precision: nil
      t.datetime "last_sign_in_at", precision: nil
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"
      t.string "authentication_token"
      t.boolean "sent"
      t.index ["authentication_token"], name: "index_partners_on_authentication_token"
      t.index ["email"], name: "index_partners_on_email", unique: true
      t.index ["reset_password_token"], name: "index_partners_on_reset_password_token", unique: true
    end

    create_table "reservations", id: :serial, force: :cascade do |t|
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

    create_table "settings", id: :serial, force: :cascade do |t|
      t.datetime "created_at", precision: nil
      t.datetime "updated_at", precision: nil
      t.string "email"
      t.datetime "deadline", precision: nil
      t.string "event_name"
      t.string "organisation_name", default: "", null: false
    end

    create_table "users", id: :serial, force: :cascade do |t|
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

    create_table "versions", id: :serial, force: :cascade do |t|
      t.string "item_type", null: false
      t.integer "item_id", null: false
      t.string "event", null: false
      t.string "whodunnit"
      t.text "object"
      t.datetime "created_at", precision: nil
      t.text "object_changes"
      t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    end

    add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
    add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  end
end
