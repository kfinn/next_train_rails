require 'rails_helper'

RSpec.describe "departures/index", type: :view do
  before(:each) do
    assign(:departures, [
      Departure.create!(),
      Departure.create!()
    ])
  end

  it "renders a list of departures" do
    render
  end
end
