class AddDepositToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :deposit, :integer, default: 0
  end
end
