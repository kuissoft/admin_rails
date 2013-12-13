require 'spec_helper'

describe 'User', :type => :feature do
  it 'cant see navbar if not signed in' do
    visit root_path

    page.should have_no_content('Users')
  end

  it 'see navbar if signed in' do
    user = FactoryGirl.build(:user)
    user.role = 1
    user.save!

    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    page.should have_content('Users')
  end
end