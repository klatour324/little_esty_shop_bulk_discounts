class BulkDiscountsController < ApplicationController
  before_action :find_merchant

  def index
    @public_holidays = NagerDateService.new("US").next_public_holidays
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)

    if @bulk_discount.save
      flash[:success] = "New Bulk Discount has been Added."

      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash.now[:errors] = @bulk_discount.errors.full_messages
      render :new
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      flash[:success] = "Your Bulk Discount ##{@bulk_discount.id} has been successfully updated"
      render :show
    else
      flash[:error] = "Bulk Discount has not been Updated. Confirm all fields are filled in with correct information. Item Threshold must be greater than 1 and Percent Discount must be greater than 0 and less than 1."

      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :item_threshold, :percent_discount)
  end
end
