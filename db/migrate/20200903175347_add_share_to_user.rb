class AddShareToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :share, null: false, foreign_key: true
  end
end
