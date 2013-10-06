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

  describe "decline" do
    it "marks the connection as declined" do
      Connection.destroy_all
      user, contact = create(:user), create(:user)
      Connection.create!(user_id: user.id, contact_id: contact.id)

      post "/api/users/#{contact.id}/contacts/decline?auth_token=#{contact.authentication_token}", {
        contact_id: user.id
      }

      Connection.count.should == 1
      conn = Connection.first
      conn.is_rejected.should be_true
      conn.is_pending.should be_false
    end
  end

  describe "remove" do
    it "removes the user's connection and marks the other side as is_removed" do
      Connection.destroy_all
      user, contact = create(:user), create(:user)
      Connection.create!(user_id: user.id, contact_id: contact.id, is_pending: false)
      Connection.create!(user_id: contact.id, contact_id: user.id, is_pending: false)

      delete "/api/users/#{contact.id}/contacts/remove?auth_token=#{contact.authentication_token}", {
        contact_id: user.id
      }

      Connection.count.should == 1
      conn = Connection.first

      conn.is_removed .should be_true
      conn.is_rejected.should be_false
      conn.is_pending .should be_false
    end
  end
end
