class AddDateTimeDigitizedToPhoto < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :date_time_digitized, :datetime
  end
end
