class AddSpecialRequestsEmailToSettings < ActiveRecord::Migration[7.1]
  def up
    add_column :settings, :special_requests_email, :string
  end
end
