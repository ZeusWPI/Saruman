class AddEventDateToSettings < ActiveRecord::Migration[7.0]
  def up
    add_column :settings, :event_date, :date, null: false, default: Date.current
  end

  def down
    remove_column :settings, :event_date
  end
end
