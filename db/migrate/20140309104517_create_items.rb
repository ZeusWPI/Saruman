class CreateItems < ActiveRecord::Migration[4.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :price

      t.timestamps
    end
  end
end
