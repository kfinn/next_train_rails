require 'rails_helper'

RSpec.describe "Departures", type: :request do
  describe "GET /departures" do
    it "works! (now write some real specs)" do
      get departures_path
      expect(response).to have_http_status(200)
    end
  end
end
