require 'rails_helper'

RSpec.describe "departures/show", type: :view do
  before(:each) do
    @departure = assign(:departure, Departure.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
