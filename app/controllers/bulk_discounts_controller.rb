class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @public_holidays = NagerDateService.new("US").next_public_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount= BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      flash[:success] = "Your Bulk Discount ##{@bulk_discount.id} has been successfully updated"
      render :show
    else
      flash[:error] = "Error: Bulk Discount has not been Updated. Please confirm
                       all fields are filled, item threshold is greater than 1
                       and percent discount is between 0 and 1."

      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :item_threshold, :percent_discount)
  end
end
