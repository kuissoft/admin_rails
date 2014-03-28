require "spec_helper"

describe Api::V1::AuthenticationController, type: :controller do
  describe "POST :authenticate" do
  	before :each do
 	 	  post :authenticate, phone: "420773646660", uuid: "3s2d4fd2f4fd2", language: "en"
 	 	end

    it "returns response 200" do    
      expect(response).to be_success
	  end
	  it "returns blank JSON object" do
      JSON.parse(response.body).should == {}
    end
  end
end