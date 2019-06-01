# == Schema Information
#
# Table name: settings
#
#  id                :integer          not null, primary key
#  created_at        :datetime
#  updated_at        :datetime
#  email             :string
#  deadline          :datetime
#  event_name        :string
#  organisation_name :string           default(""), not null
#

class Settings < ApplicationRecord
  acts_as_singleton

  validates :organisation_name, presence: true
  validates :event_name, presence: true
  validates :email, presence: true, email: true

  def expired?
    !deadline.blank? && deadline < DateTime.now
  end
end
