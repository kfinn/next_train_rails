class StopsController < ApplicationController
  def index
    @stops = Stop.root
  end

  def show
    @stop = Stop.find params[:id]
  end
end
