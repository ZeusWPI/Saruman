class DeviseCreatePartners < ActiveRecord::Migration
  def change
    create_table(:partners) do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ''

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string  :authentication_token
      t.string  :name
      t.boolean :sent, default: true

      t.string   :barcode
      t.string   :barcode_data
      t.string   :barcode_img_file_name
      t.string   :barcode_img_content_type
      t.integer  :barcode_img_file_size
      t.datetime :barcode_img_updated_at

      t.timestamps null: false
    end

    add_index :partners, :email, unique: true
    add_index :partners, :authentication_token

    remove_index :users, name: 'index_users_on_authentication_token'

    remove_column :users, :authentication_token
    remove_column :users, :role
    remove_column :users, :name
    remove_column :users, :sent
    remove_column :users, :barcode
    remove_column :users, :barcode_data
    remove_column :users, :barcode_img_file_name
    remove_column :users, :barcode_img_content_type
    remove_column :users, :barcode_img_file_size
    remove_column :users, :barcode_img_updated_at

  end
end
