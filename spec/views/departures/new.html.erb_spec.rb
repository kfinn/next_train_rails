require 'rails_helper'

RSpec.describe "departures/new", type: :view do
  before(:each) do
    assign(:departure, Departure.new())
  end

  it "renders new departure form" do
    render

    assert_select "form[action=?][method=?]", departures_path, "post" do
    end
  end
end
