class AddBarcodeImgToItemsAndPartners < ActiveRecord::Migration[4.2]
  require 'tempfile'

  def set_barcode_img(m)
    barcode = Barcodes.create('EAN13', data: m.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size

    tmpfile = Tempfile.new(%w(barcode .png))
    Barcodes::Renderer::Image.new(barcode).render(tmpfile.path)

    m.barcode_img = tmpfile

    tmpfile.close
    tmpfile.unlink

    m.save
  end

  def self.up
    add_attachment :users, :barcode_img
    add_attachment :items, :barcode_img

    User.all.each { |u| set_barcode_img(u) }
    Item.all.each { |i| set_barcode_img(i) }
  end

  def self.down
    remove_attachment :users, :barcode_img
    remove_attachment :items, :barcode_img
  end
end
