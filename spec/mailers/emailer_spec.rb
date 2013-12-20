require "spec_helper"

describe Emailer do
  describe "authentication_email" do
    let(:mail) { Emailer.authentication_email }

    it "renders the headers" do
      mail.subject.should eq("Authentication email")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
