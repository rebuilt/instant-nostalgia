class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.string :file_name
      t.string :url
      t.string :address
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
