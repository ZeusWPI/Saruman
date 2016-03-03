# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  email      :string(255)
#  deadline   :datetime
#  name       :string(255)
#

class Settings < ActiveRecord::Base
  acts_as_singleton

  validates :organisation_name, presence: true
  validates :event_name, presence: true
  validates :email, presence: true, email: true
end
