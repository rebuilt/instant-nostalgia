class RemoveMispelledCommetableFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_column :comments, :commetable_id, :integer
  end
end
