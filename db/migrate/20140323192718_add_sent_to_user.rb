class AddSentToUser < ActiveRecord::Migration
  def change
    add_column :users, :sent, :boolean, default: true
  end
end
