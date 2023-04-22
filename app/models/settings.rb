# == Schema Information
#
# Table name: settings
#
#  id                :bigint           not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  email             :string(255)
#  deadline          :datetime
#  event_name        :string(255)
#  organisation_name :string(255)      default(""), not null
#

class Settings < ApplicationRecord
  acts_as_singleton

  validates :organisation_name, presence: true
  validates :event_name, presence: true
  validates :email, presence: true, email: true

  class SettingsNotCompleteError < StandardError; end

  def expired?
    !deadline.blank? && deadline < DateTime.now
  end

  def complete?
    email.present? && event_name.present? && organisation_name.present?
  end
end
