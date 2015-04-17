require 'spec_helper'

describe "records/show" do
  before(:each) do
    @record = assign(:record, stub_model(Record,
      :caller_id => 1,
      :original_caller_id => 2,
      :assistant_id => 3,
      :ended_by => 4,
      :error => "Error"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/Error/)
  end
end
