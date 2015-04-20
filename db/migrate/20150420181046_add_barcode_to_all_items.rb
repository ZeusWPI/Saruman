class AddBarcodeToAllItems < ActiveRecord::Migration
  def change
    Item.all.each do |i|
      if i.barcode.nil?
        i.generate_barcode
        i.save
      end
    end
  end
end
