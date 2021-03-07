class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @public_holidays = NagerDateService.new("US").next_public_holidays
  end

  def show
    @bulk_discount= BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)

    if @bulk_discount.save
      flash[:success] = "New Bulk Discount has been Added."

      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:error] = "Error. Missing Fields Required."

      render :new
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def bulk_discount_params
    params.permit(:item_threshold, :percent_discount, :name)
  end
end
