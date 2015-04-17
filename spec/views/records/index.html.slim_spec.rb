require 'spec_helper'

describe "records/index" do
  before(:each) do
    assign(:records, [
      stub_model(Record,
        :caller_id => 1,
        :original_caller_id => 2,
        :assistant_id => 3,
        :ended_by => 4,
        :error => "Error"
      ),
      stub_model(Record,
        :caller_id => 1,
        :original_caller_id => 2,
        :assistant_id => 3,
        :ended_by => 4,
        :error => "Error"
      )
    ])
  end

  it "renders a list of records" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Error".to_s, :count => 2
  end
end
