require 'spec_helper'

describe "Locations" do
  it "requires an authenticaton token" do
    get locations_path(format: :json)
    response.status.should == 401
  end
end
