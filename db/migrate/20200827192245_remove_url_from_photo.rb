class RemoveUrlFromPhoto < ActiveRecord::Migration[6.0]
  def change
    remove_column :photos, :url, :string
  end
end
