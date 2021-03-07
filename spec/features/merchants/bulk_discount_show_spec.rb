require "rails_helper"

RSpec.describe "Merchant Bulk Discount Show" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = BulkDiscount.create!(item_threshold: 5, percent_discount: 0.05, name:'Senior Day Discount', merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(item_threshold: 10, percent_discount: 0.10, name:'Christmas Discount', merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(item_threshold: 15, percent_discount: 0.15, name:' 4th of July Discount', merchant_id: @merchant1.id)
    @bulk_discount_4 = BulkDiscount.create!(item_threshold: 20, percent_discount: 0.20, name:'Halloween Discount', merchant_id: @merchant1.id)
  end

  describe "When I visit my bulk discount show page" do
    it "can display the bulk discount item threshold and percent discount" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}"

        expect(page).to have_content(@bulk_discount_1.item_threshold)
        expect(page).to have_content(@bulk_discount_1.percent_discount)
        expect(page).to_not have_content(@bulk_discount_2.item_threshold)
        expect(page).to_not have_content(@bulk_discount_2.percent_discount)
      end
    end
  end
end
