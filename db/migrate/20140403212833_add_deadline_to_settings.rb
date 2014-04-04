class AddDeadlineToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :deadline, :datetime
  end
end
