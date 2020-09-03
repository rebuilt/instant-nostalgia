class AddUserAndAlbumToShare < ActiveRecord::Migration[6.0]
  def change
    add_reference :shares, :user, null: false, foreign_key: true
    add_reference :shares, :album, null: false, foreign_key: true
  end
end
