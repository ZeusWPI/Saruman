class AddDeadlineToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :deadline, :date
  end
end
