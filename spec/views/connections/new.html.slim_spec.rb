require 'spec_helper'

describe "connections/new" do
  before(:each) do
    assign(:connection, stub_model(Connection,
      :user_id => 1,
      :contact_id => 1,
      :is_pending => false
    ).as_new_record)
  end

  it "renders new connection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", connections_path, "post" do
      assert_select "input#connection_user_id[name=?]", "connection[user_id]"
      assert_select "input#connection_contact_id[name=?]", "connection[contact_id]"
      assert_select "input#connection_is_pending[name=?]", "connection[is_pending]"
    end
  end
end
