require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'

module Barcodable
  require 'tempfile'

  extend ActiveSupport::Concern

  def self.included(base)
    base.before_create :generate_barcode

    base.has_one_attached :barcode_img
  end

  def generate_barcode
    # Create it
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barby::EAN13.new(self.barcode_data)
    self.barcode = calculated_barcode.data_with_checksum

    # Attach it
    self.barcode_img.attach(io: StringIO.new(calculated_barcode.to_png(xdim: 3)), filename: "#{self.barcode}.png")
  end
end
