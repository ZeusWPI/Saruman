class ChangeApprovedToStatus < ActiveRecord::Migration
  def change
    rename_column :reservations, :approved, :status
  end
end
