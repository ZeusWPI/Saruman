class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :barcode_data
      t.string :email

      t.timestamps
    end
  end
end
