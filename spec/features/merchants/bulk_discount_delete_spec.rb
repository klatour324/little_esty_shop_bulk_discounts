require "rails_helper"

RSpec.describe "Merchant Bulk Discount Delete" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = BulkDiscount.create!(item_threshold: 5, percent_discount: 0.05, name:'Senior Day Discount', merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(item_threshold: 10, percent_discount: 0.10, name:'Christmas Discount', merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(item_threshold: 15, percent_discount: 0.15, name:' 4th of July Discount', merchant_id: @merchant1.id)
    @bulk_discount_4 = BulkDiscount.create!(item_threshold: 20, percent_discount: 0.20, name:'Halloween Discount', merchant_id: @merchant1.id)
  end

  describe "When I visit my bulk discounts index page" do
    it "can delete each bulk discount when clicking the 'Delete' link" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant1.id}/bulk_discounts"

        within(".bulk-discount-info-#{@bulk_discount_1.id}") do
          expect(page).to have_link("Delete Bulk Discount")
        end
        within(".bulk-discount-info-#{@bulk_discount_2.id}") do
          expect(page).to have_link("Delete Bulk Discount")
        end
        within(".bulk-discount-info-#{@bulk_discount_3.id}") do
          expect(page).to have_link("Delete Bulk Discount")
        end
        within(".bulk-discount-info-#{@bulk_discount_4.id}") do
          expect(page).to have_link("Delete Bulk Discount")

          click_link("Delete Bulk Discount")
        end

        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")
        expect(page).to_not have_content(@bulk_discount_4.name)
      end
    end
  end
end
