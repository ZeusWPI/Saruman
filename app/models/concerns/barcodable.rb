module Barcodable
  require 'tempfile'

  extend ActiveSupport::Concern

  def self.included(base)
    base.before_create :generate_barcode

    base.has_attached_file :barcode_img, {
      url: '/system/:hash.:extension',
      hash_secret: Rails.application.secrets.paperclip_secret
    }
    base.validates_attachment_presence :barcode_img, attachment_presence: true
    base.validates_attachment_content_type :barcode_img, content_type: /\Aimage\/.*\Z/
  end

  def generate_barcode
    # Create it
    self.barcode_data = 12.times.map { SecureRandom.random_number(10) }.join
    calculated_barcode = Barcodes.create('EAN13', data: self.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size
    self.barcode = calculated_barcode.caption_data

    # Paperclip it
    Barcodes::Renderer::Image.new(calculated_barcode).render('barcode.png')

    f = File.open('barcode.png')
    self.barcode_img = f
    f.close
  end

end
