class AddAuthenticationTokenToPartner < ActiveRecord::Migration
  def change
    add_column :partners, :authentication_token, :string
    add_index :partners, :authentication_token
  end
end
