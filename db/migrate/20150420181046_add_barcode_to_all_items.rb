class AddBarcodeToAllItems < ActiveRecord::Migration[4.2]
  def change
    Item.all.each do |i|
      if i.barcode.nil?
        i.generate_barcode
        i.save
      end
    end
  end
end
