class AddEmailToSettings < ActiveRecord::Migration[4.2]
  def change
    add_column :settings, :email, :string
  end
end
