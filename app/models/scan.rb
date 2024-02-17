class Scan
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActionView::Helpers::TextHelper

  attr_accessor :scan_items, :partner

  def scan_items
    @scan_items ||= []
  end

  def fill_scan_items
    partner.reservations.approved.joins(:item).each do |reservation|
      scan_items << ScanItem.new(reservation: reservation)
    end
  end

  def scan_items_attributes=(attributes)
    attributes.each_value do |si_attr|
      scan_items.push ScanItem.new si_attr
    end
  end

  def save
    return false unless valid?

    scan_items.each do |scan_item|
      reservation = scan_item.reservation

      reservation.increment :picked_up_count,       scan_item.pick_up.to_i
      reservation.increment :returned_used_count,   scan_item.return_used.to_i
      reservation.increment :returned_unused_count, scan_item.return_unused.to_i
      reservation.save!
    end

    true
  end

  def valid?
    super && scan_items.map(&:valid?).all?
  end

  def notification
    helpers = [
      notification_helper("picked up", :pick_up),
      notification_helper("returned used", :return_used),
      notification_helper("returned unused", :return_unused)
    ].compact

    if helpers.empty?
      "No changes"
    else
      helpers.to_sentence
    end
  end

  private

  def notification_helper(verb, method)
    items = @scan_items.select { |si| si.send(method) > 0 }.map { |si| pluralize(si.send(method), si.reservation.item.name) }

    if items.empty?
      nil
    else
      [verb, items.to_sentence].join ' '
    end
  end
end

class ScanItem
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :pick_up, :return_used, :return_unused, :reservation

  validates :pick_up,       numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :return_used,   numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :return_unused, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def initialize(attr = {})
    super(attr)
    @pick_up ||= 0
    @return_used ||= 0
    @return_unused ||= 0
  end

  def pick_up=(amount)
    @pick_up = amount.to_i
  end

  def return_used=(amount)
    @return_used = amount.to_i
  end

  def return_unused=(amount)
    @return_unused = amount.to_i
  end

  def reservation=(id)
    @reservation = Reservation.find_by_id(id)
  end
end
