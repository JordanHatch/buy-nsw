require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Disclosures::Contract::Disclosures do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::SellerApplication::Disclosures::Contract::Disclosures.new(application: application, seller: seller) }

  let(:atts) {
    {
      investigations: true,
      legal_proceedings: true,
      insurance_claims: true,
      conflicts_of_interest: true,
      other_circumstances: true,

      investigations_details: 'Information',
      legal_proceedings_details: 'Information',
      insurance_claims_details: 'Information',
      conflicts_of_interest_details: 'Information',
      other_circumstances_details: 'Information',
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  describe 'investigations' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(investigations: false, investigations_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(investigations: true, investigations_details: ''))

      expect(subject).to_not be_valid
      expect(subject.errors[:investigations_details]).to be_present
    end
  end

  describe 'legal_proceedings' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(legal_proceedings: false, legal_proceedings_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(legal_proceedings: true, legal_proceedings_details: ''))

      expect(subject).to_not be_valid
      expect(subject.errors[:legal_proceedings_details]).to be_present
    end
  end

  describe 'insurance_claims' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(insurance_claims: false, insurance_claims_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(insurance_claims: true, insurance_claims_details: ''))

      expect(subject).to_not be_valid
      expect(subject.errors[:insurance_claims_details]).to be_present
    end
  end

  describe 'conflicts_of_interest' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(conflicts_of_interest: false, conflicts_of_interest_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(conflicts_of_interest: true, conflicts_of_interest_details: ''))

      expect(subject).to_not be_valid
      expect(subject.errors[:conflicts_of_interest_details]).to be_present
    end
  end

  describe 'other_circumstances' do
    it 'is valid when false and the details field is blank' do
      subject.validate(atts.merge(other_circumstances: false, other_circumstances_details: ''))

      expect(subject).to be_valid
    end

    it 'is invalid when true and the details field is blank' do
      subject.validate(atts.merge(other_circumstances: true, other_circumstances_details: ''))

      expect(subject).to_not be_valid
      expect(subject.errors[:other_circumstances_details]).to be_present
    end
  end
end
