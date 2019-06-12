class AddDisapprovalMessageToReservation < ActiveRecord::Migration[4.2]
  def change
    add_column :reservations, :disapproval_message, :text
  end
end
