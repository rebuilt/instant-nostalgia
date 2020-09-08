class MapsController < ApplicationController
  def index
    # TODO: Add filter bar
    # TODO: Add scrollbar
    # TODO: Add photo modals
    # TODO: Add listener to recenter map on clicked-on photo
    # TODO: The current view should be extracted out into map#index and a new page for photos#index should be created here
    @photos = Photo.all.with_attached_image.belonging_to_user(current_user)
  end
end
