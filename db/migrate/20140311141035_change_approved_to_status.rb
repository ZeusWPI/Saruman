class ChangeApprovedToStatus < ActiveRecord::Migration[4.2]
  def change
    rename_column :reservations, :approved, :status
  end
end
