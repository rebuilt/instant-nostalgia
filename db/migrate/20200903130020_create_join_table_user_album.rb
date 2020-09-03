class CreateJoinTableUserAlbum < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :albums do |t|
      # t.index [:user_id, :album_id]
      # t.index [:album_id, :user_id]
    end
  end
end
