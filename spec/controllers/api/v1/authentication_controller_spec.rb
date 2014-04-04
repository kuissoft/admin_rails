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

		it "returns error 109 (bad validation code)" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :verify_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2", verification_code: "000"
			JSON.parse(response.body).should have_content('"code"=>109')
		end

		it "returns error 109 (no validation code)" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :verify_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2"
			JSON.parse(response.body).should have_content('"code"=>109')
		end

		it "returns error 111 (bad phone number)" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :verify_code, phone: "420773773773", uuid: "3s2d4fd2f4fd2", verification_code: device.verification_code
			JSON.parse(response.body).should have_content('"code"=>111')
		end

		it "returns error 111 (bad uuid)" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :verify_code, phone: "420773646660", uuid: "3333333333333", verification_code: device.verification_code
			JSON.parse(response.body).should have_content('"code"=>111')
		end

		it "returns error 106 (sms limit reached)" do
			10.times do post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en" end
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2"
			JSON.parse(response.body).should have_content('"code"=>106')
		end

	end

	describe "POST :resend_verification_code" do
		it "returns response 200" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :resend_verification_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2"
			expect(response).to be_success
		end

		it "returns blank JSON object" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :resend_verification_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2"
			JSON.parse(response.body).should == {}
		end

		it "returns error 114 (resend limit reached)" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :resend_verification_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2"
			post :resend_verification_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2"
			JSON.parse(response.body).should have_content('"code"=>114')
		end

		it "returns error 106 (sms limit reached)" do
			10.times do post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en" end
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :resend_verification_code, phone: "420773646660", uuid: "3s2d4fd2f4fd2"
			JSON.parse(response.body).should have_content('"code"=>106')
		end

		it "returns error 111 (bad phone number)" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :resend_verification_code, phone: "420773773773", uuid: "3s2d4fd2f4fd2"
			JSON.parse(response.body).should have_content('"code"=>111')
		end

		it "returns error 111 (bad uuid)" do
			post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
			device = Device.where(phone: "+420773646660", uuid: "3s2d4fd2f4fd2").first
			post :resend_verification_code, phone: "420773646660", uuid: "3333333333333"
			JSON.parse(response.body).should have_content('"code"=>111')
		end

	end

end
