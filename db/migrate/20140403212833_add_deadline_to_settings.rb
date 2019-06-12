class AddDeadlineToSettings < ActiveRecord::Migration[4.2]
  def change
    add_column :settings, :deadline, :datetime
  end
end
