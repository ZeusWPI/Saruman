class RemovePaperclipColumnsFromItem < ActiveRecord::Migration[7.0]
  def up
    remove_column :items, :barcode_img_file_name
    remove_column :items, :barcode_img_content_type
    remove_column :items, :barcode_img_file_size
    remove_column :items, :barcode_img_updated_at
  end
end
