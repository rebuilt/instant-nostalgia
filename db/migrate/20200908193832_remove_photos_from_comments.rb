class RemovePhotosFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_reference :comments, :photo, null: false, foreign_key: true
  end
end
