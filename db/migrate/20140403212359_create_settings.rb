class CreateSettings < ActiveRecord::Migration[4.2]
  def change
    create_table :settings do |t|

      t.timestamps
    end
  end
end
