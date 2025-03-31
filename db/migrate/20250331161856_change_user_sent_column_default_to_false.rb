class ChangeUserSentColumnDefaultToFalse < ActiveRecord::Migration[7.1]
  def up
    change_column_default :users, :sent, from: true, to: false
  end
end
