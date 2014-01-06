require "spec_helper"

describe "Devices" do
  it "creates a new device for a given user" do
    user = create(:user)
    token = "123-456"

    Device.destroy_all

    post "/api/devices?auth_token=#{user.auth_token}", { device: { token: token } }
    response.status.should == 200

    Device.first.token.should == token
  end

  it "doesn't accept an empty token" do
    user = create(:user)

    post "/api/devices?auth_token=#{user.auth_token}", { device: { token: nil } }
    response.status.should == 400
  end

  it "creates each device only once" do
    user = create(:user)
    token = "123-456"

    Device.destroy_all

    post "/api/devices?auth_token=#{user.auth_token}", { device: { token: token } }
    response.status.should == 200
    post "/api/devices?auth_token=#{user.auth_token}", { device: { token: token } }
    response.status.should == 200

    Device.count.should == 1
  end
end
