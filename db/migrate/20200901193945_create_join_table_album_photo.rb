class CreateJoinTableAlbumPhoto < ActiveRecord::Migration[6.0]
  def change
    create_join_table :albums, :photos do |t|
      # t.index [:album_id, :photo_id]
      # t.index [:photo_id, :album_id]
    end
  end
end
