require 'rails_helper'

RSpec.describe "departures/edit", type: :view do
  before(:each) do
    @departure = assign(:departure, Departure.create!())
  end

  it "renders the edit departure form" do
    render

    assert_select "form[action=?][method=?]", departure_path(@departure), "post" do
    end
  end
end
