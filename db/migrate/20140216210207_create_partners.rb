class CreatePartners < ActiveRecord::Migration[4.2]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :barcode_data
      t.string :email

      t.timestamps
    end
  end
end
