class AddAddressToSettings < ActiveRecord::Migration[7.1]
  def up
    add_column :settings, :address, :string
  end
end
