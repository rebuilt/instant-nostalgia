class AddVillageSuburbAndRawAddressToPhoto < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :suburb, :string
    add_column :photos, :village, :string
    add_column :photos, :raw_address, :string
  end
end
