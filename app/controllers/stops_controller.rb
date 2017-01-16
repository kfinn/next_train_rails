class StopsController < ApplicationController
  def index
    if nearby_params.count == 2
      @stops = Stop.near LatLng.new nearby_params
    else
      @stops = Stop.all
    end
  end

  def show
    @stop = Stop.find params[:id]
  end

  def nearby_params
    params.permit :latitude, :longitude
  end
end
