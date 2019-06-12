class AddNameToSettings < ActiveRecord::Migration[4.2]
  def change
    add_column :settings, :name, :string
  end
end
