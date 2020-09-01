class RemovePhotosFromAlbum < ActiveRecord::Migration[6.0]
  def change
    remove_reference :albums, :photos, null: false, foreign_key: true
  end
end
