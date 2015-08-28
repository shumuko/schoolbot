require 'rails_helper'

feature 'User creates account' do
  scenario 'and is signed into the app with their first student added' do
    district = create(:district)
    create(:school, district: district, name: 'Springfield High')
    student = create(:student,
      district: district,
      digest: Digest::SHA256.hexdigest('abc123:test:2002-03-21')
    )
    bus = create(:bus, district: district)
    create(:bus_assignment, student: student, bus: bus)
    create(:bus_location, bus: bus)
    use_subdomain(district.slug)

    visit root_path
    click_on 'Create one now'
    fill_in 'Full name', with: 'Guy Test'
    fill_in 'Email address', with: 'guy@example.com'
    fill_in 'Password', with: 'secretpass'
    fill_in 'Confirm password', with: 'secretpass'
    fill_in 'Street', with: '123 Main St'
    fill_in 'City', with: 'Someplace'
    fill_in 'State', with: 'MA'
    fill_in 'ZIP code', with: '12345'
    fill_in 'Last Name', with: 'Test'
    fill_in 'Student ID', with: 'ABC123'
    fill_in 'Birthdate', with: '3/21/2002'
    fill_in 'Nickname', with: 'Johnny'
    select 'Springfield High', from: 'School'
    check 'I accept the terms and conditions'
    click_on 'Register'

    expect(page).to have_css 'button.btn--settings'
    within('.leaflet-container') do
      expect(page).to have_css('.bus-marker', text: 'JO')
    end
  end

  scenario 'and sees error messages if bad data is input' do
    district = create(:district)
    create(:user, district: district, email: 'guy@example.com')
    use_subdomain(district.slug)

    visit root_path
    click_on 'Create one now'
    fill_in 'Email address', with: 'guy@example.com'
    fill_in 'Password', with: 'secret'
    fill_in 'Confirm password', with: 'sorcret'
    fill_in 'Last Name', with: 'Test'
    fill_in 'Student ID', with: 'ABC123'
    fill_in 'Birthdate', with: '2002-03-21'
    click_on 'Register'

    expect(page).to have_content t('errors.blank'), count: 5
    expect(page).to have_content t('errors.email.taken')
    expect(page).to have_content t('errors.password.too_short')
    expect(page).to have_content t('errors.passwordConfirmation.confirmation')
    expect(page).to have_content t('errors.digest.blank')
    expect(page).to have_content t('errors.birthdate.invalid')
    expect(page).to have_content t('errors.school.blank')
    expect(page).to have_content t('errors.accepted')
    expect(page).to_not have_content t('errors.address.invalid')
  end

  scenario 'and sees an error message if their address could not be found' do
    Geocoder::Lookup::Test.add_stub('123 Main St, Someplace, MA, 12345', [])
    use_subdomain(create(:district).slug)

    visit root_path
    click_on 'Create one now'
    fill_in 'Street', with: '123 Main St'
    fill_in 'City', with: 'Someplace'
    fill_in 'State', with: 'MA'
    fill_in 'ZIP code', with: '12345'
    click_on 'Register'

    expect(page).to have_content t('errors.address.invalid')
  end
end
