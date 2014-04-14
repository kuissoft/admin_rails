require "spec_helper"

describe Api::V1::NotificationsController, type: :controller do
	describe "GET :index" do
		it "returns notifications object" do
			device = FactoryGirl.create(:device)
			get :index, user_id: device.user.id, auth_token: device.auth_token, uuid: device.uuid
			JSON.parse(response.body).should have_content('"notifications"=>[]')
		end
	end
end