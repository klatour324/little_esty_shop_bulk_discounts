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

    it "cannot create a new bulk discount without an item threshold" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts/new"

        expect(page).to have_content("Create a New Bulk Discount")

        fill_in "bulk_discount[name]", with: "End of Bin Deal!"
        fill_in "bulk_discount[percent_discount]", with: 10

        click_button("Create Bulk discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
        expect(page).to have_content("Item threshold can't be blank")
      end
    end

    it "cannot create a new bulk discount without a percent discount" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts/new"

        expect(page).to have_content("Create a New Bulk Discount")

        fill_in "bulk_discount[name]", with: "End of Bin Deal!"
        fill_in "bulk_discount[item_threshold]", with: 5


        click_button("Create Bulk discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
        expect(page).to have_content("Percent discount can't be blank")
      end
    end

    it "cannot create a new bulk discount without a name" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts/new"

        expect(page).to have_content("Create a New Bulk Discount")

        fill_in "bulk_discount[percent_discount]", with: 10
        fill_in "bulk_discount[item_threshold]", with: 5


        click_button("Create Bulk discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
        expect(page).to have_content("Name can't be blank")
      end
    end

    it "cannot create a new bulk discount with an invalid item threshold" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts/new"

        expect(page).to have_content("Create a New Bulk Discount")

        fill_in "bulk_discount[name]", with: "End of Bin Deal!"
        fill_in "bulk_discount[percent_discount]", with: 10
        fill_in "bulk_discount[item_threshold]", with: "snahse"


        click_button("Create Bulk discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
        expect(page).to have_content("Item threshold is not a number")
      end
    end

    it "cannot create a new bulk discount with an invalid percent discount" do
      VCR.use_cassette("bulk_discount_creation") do
        visit "/merchant/#{@merchant.id}/bulk_discounts/new"

        expect(page).to have_content("Create a New Bulk Discount")

        fill_in "bulk_discount[name]", with: "End of Bin Deal!"
        fill_in "bulk_discount[percent_discount]", with: "!!!"
        fill_in "bulk_discount[item_threshold]", with: 50


        click_button("Create Bulk discount")

        expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
        expect(page).to have_content("Percent discount is not a number")
      end
    end
  end
end
