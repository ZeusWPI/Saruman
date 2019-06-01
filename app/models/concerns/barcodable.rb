require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'


module Barcodable
  require 'tempfile'

  extend ActiveSupport::Concern

  def self.included(base)
    base.before_create :generate_barcode

    base.has_attached_file :barcode_img, {
      url: '/system/:hash.:extension',
      hash_secret: Rails.application.secrets.paperclip_secret
    }
    base.validates_attachment_content_type :barcode_img, content_type: /\Aimage\/.*\Z/
  end

  def generate_barcode
    # Create it
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barby::EAN13.new(self.barcode_data)
    self.barcode = calculated_barcode.data_with_checksum

    # Paperclip it
    tmpfile = Tempfile.new(%w(barcode .png))
    File.open(tmpfile.path, 'wb') do |f|
      f.write calculated_barcode.to_png(xdim: 3)
    end

    self.barcode_img = tmpfile

    tmpfile.close
    tmpfile.unlink
  end

end
