require 'spec_helper'

describe 'User', :type => :feature do

  it 'should see his connections in his detail' do
    user = FactoryGirl.build(:user)
    user.role = 1
    user.save!

    contact = FactoryGirl.create(:user)
    contact_2 = FactoryGirl.create(:user)
    user.connections.create(contact_id: contact.id)
    user.connections.create(contact_id: contact_2.id)

    visit root_path
    fill_in 'Email', with: "user1@example.com"
    fill_in 'Password', with: "12345678"
    click_button 'Sign in'

    page.should have_content(user.name)

    click_link user.name
    
    page.should have_content(contact.name)
    page.should have_content(contact_2.name)
  end
end