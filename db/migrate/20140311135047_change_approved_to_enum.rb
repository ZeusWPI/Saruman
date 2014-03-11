class ChangeApprovedToEnum < ActiveRecord::Migration
  def change
    change_column :reservations, :approved, :integer, default: 1
  end
end
