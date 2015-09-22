require 'spec_helper'

describe "records/new" do
  before(:each) do
    assign(:record, stub_model(Record,
      :caller_id => 1,
      :original_caller_id => 1,
      :assistant_id => 1,
      :ended_by => 1,
      :error => "MyString"
    ).as_new_record)
  end

  it "renders new record form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", records_path, "post" do
      assert_select "input#record_caller_id[name=?]", "record[caller_id]"
      assert_select "input#record_original_caller_id[name=?]", "record[original_caller_id]"
      assert_select "input#record_assistant_id[name=?]", "record[assistant_id]"
      assert_select "input#record_ended_by[name=?]", "record[ended_by]"
      assert_select "input#record_error[name=?]", "record[error]"
    end
  end
end
