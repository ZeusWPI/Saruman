# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  authentication_token   :string
#  barcode                :string
#  barcode_data           :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           default("partner")
#  sent                   :boolean          default(TRUE)
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  verify_fixtures User
  # test "the truth" do
  #   assert true
  # end
  #

  test "should generate barcode" do
    u = User.new
    u.name = "Benoit"
    u.email = "benoit@test.com"
    u.password = "testtest"
    u.save!

    assert_not_nil u.barcode
    assert_not_nil u.barcode_data
  end
end
