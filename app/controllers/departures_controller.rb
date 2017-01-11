class DeparturesController < ApplicationController
  # GET /departures
  # GET /departures.json
  def index
    @departures = DeparturesCollection.all
  end
end
