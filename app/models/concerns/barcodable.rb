module Barcodable
  extend ActiveSupport::Concern

  def self.included(base)
    base.before_create :generate_barcode
  end

  def generate_barcode
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barcodes.create('EAN13', data: self.barcode_data)
    self.barcode = calculated_barcode.caption_data
  end

end
