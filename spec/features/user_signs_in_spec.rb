require 'rails_helper'

feature 'User signs in' do
  before do
    district = create(:district, slug: 'boston')
    create(:user,
      district: district,
      email: 'bob@example.com',
      password: 'secretpass'
    )
  end

  scenario 'successfully and is sent to the main page' do
    use_subdomain('boston')

    visit root_path
    click_on 'Sign In'
    fill_in 'Your email', with: 'bob@example.com'
    fill_in 'Password', with: 'secretpass'
    click_on 'Submit'

    expect(page).to have_content 'Signed into district'
  end

  scenario 'unsuccessfully due to invalid credentials' do
    use_subdomain('boston')

    visit root_path
    click_on 'Sign In'
    fill_in 'Your email', with: 'bob@example.com'
    fill_in 'Password', with: ''
    click_on 'Submit'

    expect(page).to have_content 'Invalid email or password'
  end

  scenario 'unsuccessfully due to using the wrong subdomain' do
    create(:district, slug: 'district13')
    use_subdomain('district13')

    visit root_path
    click_on 'Sign In'
    fill_in 'Your email', with: 'bob@example.com'
    fill_in 'Password', with: 'secretpass'
    click_on 'Submit'

    expect(page).to have_content 'Invalid email or password'
  end
end