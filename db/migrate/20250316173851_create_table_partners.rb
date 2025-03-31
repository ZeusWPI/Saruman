class CreateTablePartners < ActiveRecord::Migration[7.1]
  def change
    # Remove old obsolete partners table
    drop_table :partners

    # Add partners table
    create_table :partners do |t|
      t.timestamps
      t.string :name, null: false, index: {unique: true}
      t.string :barcode, null: false
      t.string :barcode_data, null: false
    end

    # Add column "partner_id" to users
    add_reference :users, :partner, foreign_key: true, null: true

    # Create a partner for each partner user
    User.partners.find_each do |user|
      partner = Partner.create!(
        name: user.name,
        barcode: user.barcode,
        barcode_data: user.barcode_data
      )

      user.update!(partner: partner)
    end

    # Add column "partner_id" to reservations
    add_reference :reservations, :partner, foreign_key: true

    # Set all reservations to the partner of the user
    Reservation.all.find_each do |reservation|
      reservation.update!(partner: reservation.user.partner)
    end

    # Remove columns "barcode" and "barcode_data" from users
    remove_column :users, :barcode, :string
    remove_column :users, :barcode_data, :string

    # Remove column "user_id" from reservations
    remove_reference :reservations, :user, foreign_key: false
  end
end
