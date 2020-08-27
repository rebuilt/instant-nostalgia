class RemoveLongitudeFromPhoto < ActiveRecord::Migration[6.0]
  def change
    remove_column :photos, :longitude, :string
  end
end
