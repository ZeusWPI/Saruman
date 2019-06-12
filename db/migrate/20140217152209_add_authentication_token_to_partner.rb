class AddAuthenticationTokenToPartner < ActiveRecord::Migration[4.2]
  def change
    add_column :partners, :authentication_token, :string
    add_index :partners, :authentication_token
  end
end
