module Sellers::SellerApplication::Contract
  class FinancialStatement < Base
    feature Reform::Form::ActiveModel::FormBuilderMethods
    feature Reform::Form::MultiParameterAttributes

    property :financial_statement_file,        on: :seller
    property :financial_statement_expiry, on: :seller, multi_params: true

    validation :default, inherit: true do
      required(:seller).schema do
        required(:financial_statement_file).filled(:file?)
        required(:financial_statement_expiry).filled(:date?)
      end
    end
  end
end