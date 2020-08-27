class AddAddressDetailsToPhoto < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :city, :string
    add_column :photos, :state, :string
    add_column :photos, :state_code, :string
    add_column :photos, :postal_code, :string
    add_column :photos, :country, :string
    add_column :photos, :country_code, :string
  end
end
