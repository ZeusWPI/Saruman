class AddSentToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :sent, :boolean, default: true
  end
end
