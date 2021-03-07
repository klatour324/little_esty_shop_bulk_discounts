require "rails_helper"

RSpec.describe "Merchant Bulk Discount Edit Page" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = BulkDiscount.create!(item_threshold: 5, percent_discount: 0.05, name:'Senior Day Discount', merchant_id: @merchant1.id)
  end

  describe "When I am taken to my Merchant Bulk Discount Edit Page" do
    it "has an edit form with the fields pre-populated, and I can update any/all info with valid data" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}"

        expect(page).to have_content(@bulk_discount_1.name)
        expect(page).to have_content(@bulk_discount_1.item_threshold)
        expect(page).to have_content(@bulk_discount_1.percent_discount)

        expect(page).to have_link("Edit Bulk Discount")

        click_link("Edit Bulk Discount")

        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}/edit")

        expect(page).to have_content("Edit Bulk Discount")

        fill_in("bulk_discount[name]", with: "Summer Solstice Blowout!")
        fill_in("bulk_discount[item_threshold]", with: 10)
        fill_in("bulk_discount[percent_discount]", with: 0.10)

        click_button("Update Bulk Discount")

        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}")

        expect(page).to have_content("Summer Solstice Blowout!")
        expect(page).to have_content("Item Threshold: 10")
        expect(page).to have_content("Percent Discount: 0.1")
      end
    end

    it "cannot edit a form with invalid input on form" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}/edit"

        fill_in("bulk_discount[name]", with: "")
        fill_in("bulk_discount[item_threshold]", with: 100)
        fill_in("bulk_discount[percent_discount]", with: 0.0)

        click_button("Update Bulk Discount")

        expect(page).to have_content("Bulk Discount has not been Updated. Confirm all fields are filled in with correct information. Item Threshold must be greater than 1 and Percent Discount must be greater than 0 and less than 1.")
        expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/#{@bulk_discount_1.id}/edit")
        expect(page).to have_button("Update Bulk Discount")
      end
    end
  end
end
