require 'rails_helper'

RSpec.describe Sellers::Applications::DeclarationForm do

  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::Applications::DeclarationForm.new(application: application, seller: seller) }

  it 'can save with terms acceptance' do
    subject.validate({
      agree: true
    })

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when terms are not accepted' do
    subject.validate({
      agree: false
    })

    expect(subject).to_not be_valid
    expect(subject.errors[:agree]).to be_present
  end
end