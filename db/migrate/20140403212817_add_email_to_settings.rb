class AddEmailToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :email, :string
  end
end
