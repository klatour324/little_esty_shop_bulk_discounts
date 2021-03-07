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

    it "can edit the bulk discount information when clicking the edit link" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}"

        expect(page).to have_link("Edit Bulk Discount")

        click_link("Edit Bulk Discount")

        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}/edit")
      end
    end
  end
end

# When I visit my bulk discount show page
# Then I see a link to edit the bulk discount
# When I click this link
# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
