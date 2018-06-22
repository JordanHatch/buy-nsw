require 'rails_helper'

RSpec.describe 'Seller dashboard', type: :feature do

  it 'shows a message to sellers awaiting review' do
    seller = create(:inactive_seller_with_full_profile, owner: @user)
    create(:ready_for_review_seller_application, seller: seller)

    visit '/'
    click_on 'Your seller account'

    expect(page).to have_content('Seller dashboard')
    expect(page).to have_content("We'll be in touch by email soon with the outcome of your application")
  end

  it 'shows a message to sellers with an active profile' do
    seller = create(:active_seller, owner: @user)

    visit '/'
    click_on 'Your seller account'

    expect(page).to have_content('Seller dashboard')
    expect(page).to have_content('Your seller account is active')
  end


end
