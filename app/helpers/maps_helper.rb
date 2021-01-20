module MapsHelper
  def remove_non_geocoded(photos)
    photos.reject { |photo| photo.location? == false }
  end

  def load_area_names(area)
    locations = Photo.belonging_to_user(current_user).distinct.pluck(area)
    locations.reject(&:nil?)
  end

  def add_message(filtered_by, value)
    flash.now[:message] = flash.now[:message] + "  #{filtered_by}: #{value} |"
  end
end
