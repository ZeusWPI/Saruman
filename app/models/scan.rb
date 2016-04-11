class Scan
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :scan_items, :partner

  def scan_items
    @scan_items ||= []
  end

  def fill_scan_items
    partner.reservations.joins(:item).each do |reservation|
      scan_items << ScanItem.new(reservation: reservation)
    end
  end

  def scan_items_attributes= attributes
    attributes.each do |_, si_attr|
      scan_items.push ScanItem.new si_attr
    end
  end

  def save
    return false unless valid?

    scan_items.each do |res|
      res.reservation.increment :picked_up_count,    res.pick_up.to_i
      res.reservation.increment :brought_back_count, res.bring_back.to_i
      res.reservation.save
    end

    true
  end

  def valid?
    super && scan_items.map(&:valid?).all?
  end
end

class ScanItem
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :pick_up, :bring_back, :reservation

  validates :pick_up,    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :bring_back, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def initialize attr = {}
    super attr
    @pick_up    ||= 0
    @bring_back ||= 0
  end

  def reservation= id
    @reservation = Reservation.find id
  end
end
