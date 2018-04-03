class Sellers::SearchController < Sellers::BaseController
  def search
  end

private
  def search
    @search ||= SellerSearch.new(
      term: params[:q],
      selected_filters: params.except(:q),
    )
  end
  helper_method :search
end
