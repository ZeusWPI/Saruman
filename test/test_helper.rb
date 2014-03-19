# Coverage testing
require 'coveralls'
Coveralls.wear!('rails')

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def self.verify_fixtures(clazz)
    test "fixtures for #{clazz.name} should validate" do
     clazz.all.map { |o|  assert o.valid?, o.inspect.to_s + "\n" + o.errors.full_messages.join("\n") }
   end
  end
end
