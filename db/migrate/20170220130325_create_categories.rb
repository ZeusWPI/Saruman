class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name,     null: false, default: ''
      t.date   :deadline, null: false

      t.timestamps null: false
    end

    remove_column :items, :category, :integer
    add_reference :items, :category
  end
end
