require "rails_helper"

RSpec.describe "Merchant Bulk Discount Create Page" do
  before :each do
    @merchant = Merchant.create!(name: 'Pawtrait Designs')
  end

  describe "Bulk discount creation" do
    it "user can create a new discount" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts"

        expect(page).to have_link("Create New Discount")

        click_link("Create New Discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/new")
        expect(page).to have_content("Create a New Bulk Discount")

        fill_in "name", with: "End of Bin Deal!"
        fill_in "item_threshold", with: 5
        fill_in "percent_discount", with: 0.10

        click_button("Add New Bulk Discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
        expect(page).to have_content("End of Bin Deal!")
      end
    end

    it "cannot create a new bulk discount unless all required fields of form are filled out" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts/new"

        click_button("Add New Bulk Discount")

        expect(page).to have_content("Error. Missing Fields Required.")
        expect(page).to have_button("Add New Bulk Discount")
      end
    end
  end
end
