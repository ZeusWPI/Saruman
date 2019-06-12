class AddDefaultValueToApproved < ActiveRecord::Migration[4.2]

  def up
    change_column :reservations, :approved, :boolean, default: false
  end

  def down
    change_column :reservations, :approved, :boolean
  end
end
