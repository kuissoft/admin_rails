require 'spec_helper'

describe "connections/show" do
  before(:each) do
    @connection = assign(:connection, stub_model(Connection,
      :user_id => 1,
      :contact_id => 2,
      :is_pending => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/false/)
  end
end
