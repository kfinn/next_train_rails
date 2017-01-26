class StopsController < ApplicationController
  def index
    if nearby_params[:latitude] && nearby_params[:longitude]
      @stops = ParentStop.near LatLng.new nearby_params
    else
      @stops = ParentStop.visible
    end
  end

  def show
    @stop = ParentStop.find params[:id]
  end

  def nearby_params
    params.permit :latitude, :longitude
  end
end
