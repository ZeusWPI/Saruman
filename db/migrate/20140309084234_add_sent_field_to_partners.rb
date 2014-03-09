class AddSentFieldToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :sent, :boolean
  end
end
