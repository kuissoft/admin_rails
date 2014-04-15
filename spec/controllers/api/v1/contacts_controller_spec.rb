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

	describe "POST :invite" do
		it "returns response 200" do
			device = FactoryGirl.create(:device)
			post :invite, user_id: device.user.id, auth_token: device.auth_token,
						uuid: device.uuid, contact: { nickname: 'xexe', phone: '420987654321' }
			expect(response).to be_success
		end

		it "returns invited_user JSON object" do
			device = FactoryGirl.create(:device)
			post :invite, user_id: device.user.id, auth_token: device.auth_token,
			      uuid: device.uuid, contact: { nickname: 'xexe', phone: '420987654321' }
			JSON.parse(response.body).should have_content('"invited_user"')
		end

		# it "returns notifications object" do
		# 	device = FactoryGirl.create(:device)
		# 	post :invite, user_id: device.user.id, auth_token: device.auth_token,
		# 				uuid: device.uuid, contact: { nickname: 'xexe', phone: '420987654321' }
		# 	get :index, user_id: device.user.id, auth_token: device.auth_token, uuid: device.uuid
		# 	JSON.parse(response.body).should have_content('"notifications"=>[]')
		# end

		# it "returns error 108 (connection already exists)" do
		# 	device = FactoryGirl.create(:device)
		# 	post :invite, user_id: device.user.id, auth_token: device.auth_token,
		# 	      uuid: device.uuid, contact: { nickname: 'xexe', phone: '420987654321' }
		# 	post :invite, user_id: device.user.id, auth_token: device.auth_token,
		# 	      uuid: device.uuid, contact: { nickname: 'xexe', phone: '420987654321' }
		# 	JSON.parse(response.body).should have_content('"code"=>108')
		# end

		# it "returns error 101 (blank contact phone)" do
		# 	device = FactoryGirl.create(:device)
		# 	post :invite, user_id: device.user.id, auth_token: device.auth_token,
		# 	      uuid: device.uuid, contact: { nickname: 'xexe', phone: '' }
		# 	JSON.parse(response.body).should have_content('"code"=>101')
		# end
	end

	describe "POST :accept" do
		# it "returns blank JSON object" do
		# 	device1 = FactoryGirl.create(:device)
		# 	device2 = FactoryGirl.create(:device)
		# 	post :invite, user_id: device1.user_id, auth_token: device1.auth_token,
		# 				uuid: device1.uuid, contact: { nickname: 'xexe', phone: '420123456782' }
		# 	puts Device.where(user_id: device1.user_id, uuid: device1.uuid).first.inspect
		# 	puts Device.where(user_id: device2.user_id, uuid: device2.uuid).first.inspect
		# 	puts "========================"
		# 	puts User.where(id: device1.user_id).first.inspect
		# 	puts User.where(id: device2.user_id).first.inspect
		# 	puts "========================"
		# 	puts Connection.where(user_id: device1.user_id, contact_id: device2.user_id).first.inspect
		# 	post :accept, user_id: device2.user_id, auth_token: device2.auth_token,
		# 	      uuid: device2.uuid, contact_id: device1.user_id
		# 	JSON.parse(response.body).should == {}
		# end
	end

	# describe "POST :decline" do
	# 	it "returns blank JSON object" do
			
	# 		JSON.parse(response.body).should == {}
	# 	end
	# end

	# describe "DELETE :remove" do
	# 	it "returns blank JSON object" do
			
	# 		JSON.parse(response.body).should == {}
	# 	end
	# end

	# describe "DELETE :dismiss" do
	# 	it "returns blank JSON object" do
			
	# 		JSON.parse(response.body).should == {}
	# 	end
	# end
end
