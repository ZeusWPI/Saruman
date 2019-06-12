class AddRoleToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :role, :string, default: "partner"
  end
end
