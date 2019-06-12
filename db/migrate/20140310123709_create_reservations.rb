class CreateReservations < ActiveRecord::Migration[4.2]
  def change
    create_table :reservations do |t|
      t.references :item, index: true
      t.references :partner, index: true
      t.integer :count
      t.integer :fetched
      t.integer :brought_back

      t.timestamps
    end
  end
end
