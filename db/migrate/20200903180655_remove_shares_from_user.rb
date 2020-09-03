class RemoveSharesFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_reference :users, :share, null: false, foreign_key: true
  end
end
