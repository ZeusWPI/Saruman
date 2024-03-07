class AddNonNullToSettingsAddress < ActiveRecord::Migration[7.1]
  def up
    change_column_null :settings, :address, false
  end
end
