class AddQuantityToItems < ActiveRecord::Migration
  def change
    add_column :items, :quantity, :integer
  end
end
