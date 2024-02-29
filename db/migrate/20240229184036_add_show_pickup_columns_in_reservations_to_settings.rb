class AddShowPickupColumnsInReservationsToSettings < ActiveRecord::Migration[7.0]
  def up
    add_column :settings, :show_pickup_columns_in_reservations, :boolean, default: false, null: false
  end

  def down
    remove_column :settings, :show_pickup_columns_in_reservations
  end
end
