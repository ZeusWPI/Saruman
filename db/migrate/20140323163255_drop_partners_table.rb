class DropPartnersTable < ActiveRecord::Migration[4.2]
  def change
    drop_table :partners
  end
end
