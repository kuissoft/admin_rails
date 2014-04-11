require "spec_helper"

describe Api::V1::ContactsController, type: :controller do
	describe "GET :index" do
		it "returns response 200" do
			device = FactoryGirl.create(:device)
			get :index, user_id: device.user.id, auth_token: device.auth_token, uuid: device.uuid
			expect(response).to be_success
		end

		it "returns contacts JSON object" do
			device = FactoryGirl.create(:device)
			get :index, user_id: device.user.id, auth_token: device.auth_token, uuid: device.uuid
			JSON.parse(response.body).should have_content('"contacts"')
		end

		it "returns error 104 - User is not authenticated" do
			device = FactoryGirl.create(:device)
			device.destroy
			get :index, user_id: device.user.id, auth_token: device.auth_token, uuid: device.uuid
			JSON.parse(response.body).should have_content('"code"=>104')
		end
	end
end
