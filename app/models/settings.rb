class Settings < ApplicationRecord
  acts_as_singleton

  validates :organisation_name, presence: true
  validates :event_name, presence: true
  validates :email, presence: true, email: true

  class SettingsNotCompleteError < StandardError; end

  def expired?
    deadline.present? && deadline < DateTime.current
  end

  def complete?
    email.present? && event_name.present? && organisation_name.present?
  end
end

# == Schema Information
#
# Table name: settings
#
#  id                                  :integer          not null, primary key
#  deadline                            :datetime
#  email                               :string
#  event_date                          :date             default(Thu, 29 Feb 2024), not null
#  event_name                          :string
#  organisation_name                   :string           default(""), not null
#  show_pickup_columns_in_reservations :boolean          default(FALSE), not null
#  created_at                          :datetime
#  updated_at                          :datetime
#
