class CreateReservations < ActiveRecord::Migration
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
