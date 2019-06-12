class RemoveFetchedFieldFromReservations < ActiveRecord::Migration[4.2]
  def change
    remove_column :reservations, :fetched, :integer
  end
end
