require "spec_helper"

describe User do
  it "new user automatically gets an authentication token" do
    user = FactoryGirl.create(:user)
    user.auth_token.should be_present
  end

  it "user gets a new authenticaton token if he doesn't get one" do
    user = FactoryGirl.create(:user)
    user.auth_token = nil
    user.save!

    user.auth_token.should be_present
  end

  describe "Connections" do
    it "user gets true if contact follows him" do
      user = FactoryGirl.create(:user)
      contact = FactoryGirl.create(:user)
      contact.connections.create(contact_id: user.id)

      user.follows_me?(contact.id).should be_true
    end

    it "user gets false if contact not follows him" do
      user = FactoryGirl.create(:user)
      contact = FactoryGirl.create(:user)

      user.follows_me?(contact.id).should be_false
    end

    it "user gets true if following contact" do
      user = FactoryGirl.create(:user)
      contact = FactoryGirl.create(:user)
      user.connections.create(contact_id: contact.id)

      user.following?(contact.id).should be_true
    end

    it "user gets false if not following contact" do
      user = FactoryGirl.create(:user)
      contact = FactoryGirl.create(:user)

      user.following?(contact.id).should be_false
    end

    it "user gets array of followers ids" do
      user = FactoryGirl.create(:user)
      contact_1 = FactoryGirl.create(:user)
      contact_2 = FactoryGirl.create(:user)
      contact_1.connections.create(contact_id: user.id)
      contact_2.connections.create(contact_id: user.id)

      user.followers.should == [contact_1.id, contact_2.id]
    end

    it "user gets empty array if he has no followers" do
      user = FactoryGirl.create(:user)

      user.followers.should == []
    end

    it "user gets array of following ids" do
      user = FactoryGirl.create(:user)
      contact_1 = FactoryGirl.create(:user)
      contact_2 = FactoryGirl.create(:user)
      user.connections.create(contact_id: contact_1.id)
      user.connections.create(contact_id: contact_2.id)

      user.following.should == [contact_1.id, contact_2.id]
    end

    it "user gets empty array if he is following no one" do
      user = FactoryGirl.create(:user)

      user.following.should == []
    end

    it "user gets array of users ids he follows and they follow him" do
      user = FactoryGirl.create(:user)
      contact_1 = FactoryGirl.create(:user)
      contact_2 = FactoryGirl.create(:user)
      contact_1.connections.create(contact_id: user.id)
      user.connections.create(contact_id: contact_1.id)
      user.connections.create(contact_id: contact_2.id)

      user.following_each_other.should == [contact_1.id]
    end

    it "user gets empty array if he is following no one and nobody following him" do
      user = FactoryGirl.create(:user)

      user.following_each_other.should == []
    end

    it "user gets array of unique users ids he follows or they follow him" do
      user = FactoryGirl.create(:user)
      contact_1 = FactoryGirl.create(:user)
      contact_2 = FactoryGirl.create(:user)
      contact_1.connections.create(contact_id: user.id)
      user.connections.create(contact_id: contact_1.id)
      user.connections.create(contact_id: contact_2.id)

      user.followers_uniq.should == [contact_1.id, contact_2.id]
    end

    it "user gets empty array of unique users ids he follows or they follow him" do
      user = FactoryGirl.create(:user)

      user.followers_uniq.should == []
    end

    it "user gets Connection object with current contact" do
      user = FactoryGirl.create(:user)
      contact_1 = FactoryGirl.create(:user)
      user.connections.create(contact_id: contact_1.id)

      user.get_connection(contact_1.id).should_not be_nil
    end

    it "user gets nil Connection object if no connection exists" do
      user = FactoryGirl.create(:user)
      contact_1 = FactoryGirl.create(:user)

      user.get_connection(contact_1.id).should be_nil
    end

  end
end
