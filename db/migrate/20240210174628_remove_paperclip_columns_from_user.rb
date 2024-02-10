class RemovePaperclipColumnsFromUser < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :barcode_img_file_name
    remove_column :users, :barcode_img_content_type
    remove_column :users, :barcode_img_file_size
    remove_column :users, :barcode_img_updated_at
  end
end
