require "spec_helper"

describe Api::V1::AuthenticationController, type: :controller do
	describe "POST :authenticate" do
		it "returns response 200" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			expect(response).to be_success
		end
		
		it "returns blank JSON object" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			JSON.parse(response.body).should == {}
		end

		# it "returns error 101 - blank number" do
		# 	post :authenticate, phone: "", uuid: "3s2d4fd2f4fd2", language: "en"
		# 	JSON.parse(response.body).should have_content('"code"=>101')
		# end

		it "returns error 106 - Cannot send verification SMS (country code is missing)" do
			post :authenticate, phone: "773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 106 - Cannot send verification SMS (phone number is blank)" do
			post :authenticate, phone: "", uuid: "3s2d4fd2f4fd2", language: "en"
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 106 - Cannot send verification SMS (phone number is too short)" do
			post :authenticate, phone: "646660", uuid: "3s2d4fd2f4fd2", language: "en"
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 106 - Cannot send verification SMS (phone number is too long)" do
			post :authenticate, phone: "4207736466601112", uuid: "3s2d4fd2f4fd2", language: "en"
			JSON.parse(response.body).should have_content('"code"=>106')
		end
	end

	describe "POST :verify_code" do
		it "returns response 200" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :verify_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2", verification_code: device.verification_code
			expect(response).to be_success
		end

		it "returns JSON object \"user\"" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :verify_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2", verification_code: device.verification_code
			JSON.parse(response.body).should have_content('"phone"=>"+420773646660"')
		end
	end

end
