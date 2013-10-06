require "spec_helper"

describe "Contacts" do
  describe "contact creation" do
    it "creates a pending connection" do
      Connection.destroy_all
      user, contact = create(:user), create(:user)

      post "/api/users/#{user.id}/contacts?auth_token=#{user.authentication_token}", {
        contact: { contact_id: contact.id }
      }

      response.status.should == 200
      Connection.first.is_pending.should be_true
    end
  end

  describe "accept" do
    it "accepts the connection, creates inverse one and notifies the contact" do
      Connection.destroy_all
      user, contact = create(:user), create(:user)
      Connection.create!(user_id: user.id, contact_id: contact.id)

      post "/api/users/#{contact.id}/contacts/accept?auth_token=#{contact.authentication_token}", {
        contact_id: user.id
      }

      Connection.count.should == 2
    end
  end
end
