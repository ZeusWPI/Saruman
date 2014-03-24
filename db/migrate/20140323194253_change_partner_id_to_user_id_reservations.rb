class ChangePartnerIdToUserIdReservations < ActiveRecord::Migration
  def change
    rename_column :reservations, :partner_id, :user_id
  end
end
