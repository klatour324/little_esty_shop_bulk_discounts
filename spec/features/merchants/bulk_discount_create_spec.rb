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

        fill_in "bulk_discount[name]", with: "End of Bin Deal!"
        fill_in "bulk_discount[item_threshold]", with: 5
        fill_in "bulk_discount[percent_discount]", with: 10

        click_button("Create Bulk discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
        expect(page).to have_content("End of Bin Deal!")

      end
    end

    it "cannot create a new bulk discount unless all required fields of form are filled out" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts/new"

        click_button("Create Bulk discount")

        expect(page).to have_content("Error. Name must be filled out. Item threshold must be greater than 1. Percent discount must be greater than 0 and less than 1.")
        expect(page).to have_button("Create Bulk discount")
      end
    end
  end
end
