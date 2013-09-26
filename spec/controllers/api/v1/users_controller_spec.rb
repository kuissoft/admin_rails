require "spec_helper"

describe Api::V1::UsersController, type: :controller do
  describe "POST :create" do
    it "responds with the actual error messages" do
      post :create, user: { name: "" }
      JSON.parse(response.body).should have_key("errors")
    end
  end
end
