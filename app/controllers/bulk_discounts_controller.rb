class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @public_holidays = NagerDateService.new("US").next_public_holidays
  end
end
