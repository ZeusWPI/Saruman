class ChangeApprovedToEnum < ActiveRecord::Migration[4.2]
  def change
    change_column :reservations, :approved, :integer, default: 1
  end
end
