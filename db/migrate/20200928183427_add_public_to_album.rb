class AddPublicToAlbum < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :public, :boolean
  end
end
