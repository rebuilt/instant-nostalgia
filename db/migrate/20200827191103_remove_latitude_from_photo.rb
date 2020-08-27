class RemoveLatitudeFromPhoto < ActiveRecord::Migration[6.0]
  def change
    remove_column :photos, :latitude, :string
  end
end
