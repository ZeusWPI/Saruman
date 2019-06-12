class AddSentFieldToPartners < ActiveRecord::Migration[4.2]
  def change
    add_column :partners, :sent, :boolean
  end
end
