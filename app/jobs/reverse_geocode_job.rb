class ReverseGeocodeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    photo = args[0]
    photo.init_address
    photo.save
    puts photo
  end
end
