class AddDisapprovalMessageToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :disapproval_message, :text
  end
end
