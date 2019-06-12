class AddQuantityToItems < ActiveRecord::Migration[4.2]
  def change
    add_column :items, :quantity, :integer
  end
end
