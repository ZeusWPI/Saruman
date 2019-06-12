class ChangePartnerIdToUserIdReservations < ActiveRecord::Migration[4.2]
  def change
    rename_column :reservations, :partner_id, :user_id
  end
end
