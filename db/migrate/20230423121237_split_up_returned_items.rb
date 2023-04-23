class SplitUpReturnedItems < ActiveRecord::Migration[5.2]
  def change
    rename_column :reservations, :brought_back_count, :returned_unused_count
    add_column :reservations, :returned_used_count, :integer, default: 0
  end
end
