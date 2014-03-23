class AddRoleToUsers < ActiveRecord::Migration
  def change
    add_column :users, :role, :string, default: "partner"
  end
end
