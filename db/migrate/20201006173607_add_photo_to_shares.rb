class AddPhotoToShares < ActiveRecord::Migration[6.0]
  def change
    add_reference :shares, :photo, null: false, foreign_key: true
  end
end
