require "spec_helper"

describe Connection do
  it "doesn't allow duplicate connections" do
    a, b = create(:user), create(:user)

    Connection.create(user: a, contact: b)
    conn = Connection.create(user: a, contact: b)
    conn.should have(1).error_on(:user_id)
  end

  it "doesn't allow setting yourself as a contact" do
    user = create(:user)
    conn = Connection.create(user: user, contact: user)
    conn.should have(1).error_on(:contact_id)
  end
end
