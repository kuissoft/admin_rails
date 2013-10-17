require 'spec_helper'

describe Settings do
  it "has a valid factory" do
    build(:settings).should be_valid
  end
end
