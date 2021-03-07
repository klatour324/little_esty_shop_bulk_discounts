require "rails_helper"

RSpec.describe "Merchant Bulk Discount Create Page" do
  before :each do
    @merchant = Merchant.create!(name: 'Pawtrait Designs')
    # @bulk_discount_1 = BulkDiscount.create!(item_threshold: 5, percent_discount: 0.05, name:'Senior Day Discount', merchant_id: @merchant1.id)
    # @bulk_discount_2 = BulkDiscount.create!(item_threshold: 10, percent_discount: 0.10, name:'Christmas Discount', merchant_id: @merchant1.id)
    # @bulk_discount_3 = BulkDiscount.create!(item_threshold: 15, percent_discount: 0.15, name:' 4th of July Discount', merchant_id: @merchant1.id)
    # @bulk_discount_4 = BulkDiscount.create!(item_threshold: 20, percent_discount: 0.20, name:'Halloween Discount', merchant_id: @merchant1.id)
  end

  describe "When I visit my bulk discounts index" do
    it "shows a link to create a new discount" do
      VCR.use_cassette("nager_data_service_next_public_holidays") do
        visit merchant_bulk_discounts_path(@merchant)

        expect(page).to have_link("Create New Discount")

        click_link("Create New Discount")

        expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
      end
    end
  end
end

# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed
