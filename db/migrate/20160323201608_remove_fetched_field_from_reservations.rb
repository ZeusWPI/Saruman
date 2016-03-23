class RemoveFetchedFieldFromReservations < ActiveRecord::Migration
  def change
    remove_column :reservations, :fetched, :integer
  end
end
