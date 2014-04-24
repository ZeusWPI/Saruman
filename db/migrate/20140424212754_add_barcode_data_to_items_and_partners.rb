class AddBarcodeDataToItemsAndPartners < ActiveRecord::Migration
  def change
    add_column :items, :barcode, :string
    add_column :items, :barcode_data, :string
    add_column :users, :barcode, :string
    add_column :users, :barcode_data, :string

    User.all.each { |u| u.generate_barcode }
    Item.all.each { |i| i.generate_barcode }
  end
end
