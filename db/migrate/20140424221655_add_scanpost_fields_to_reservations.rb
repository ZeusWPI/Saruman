class AddScanpostFieldsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :picked_up_count, :integer, default: 0
    add_column :reservations, :brought_back_count, :integer, default: 0
  end
end
