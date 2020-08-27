class AddLatLongToPhoto < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :latitude_in_degrees, :string
    add_column :photos, :latitude_in_decimal, :float
    add_column :photos, :longitude_in_degrees, :string
    add_column :photos, :longitude_in_decimal, :float
  end
end
