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
