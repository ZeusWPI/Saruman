# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  email      :string(255)
#  deadline   :datetime
#

class Settings < ActiveRecord::Base
  acts_as_singleton

  validates :name, presence: true
  validates :email, presence: true, email: true
end
