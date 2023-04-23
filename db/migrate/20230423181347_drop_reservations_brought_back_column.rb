class DropReservationsBroughtBackColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :brought_back
  end
end
