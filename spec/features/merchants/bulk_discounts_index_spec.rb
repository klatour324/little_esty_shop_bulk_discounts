require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Index" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = BulkDiscount.create!(item_threshold: 5, percent_discount: 0.05, name:'Senior Day Discount', merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(item_threshold: 10, percent_discount: 0.10, name:'Christmas Discount', merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(item_threshold: 15, percent_discount: 0.15, name:' 4th of July Discount', merchant_id: @merchant1.id)
    @bulk_discount_4 = BulkDiscount.create!(item_threshold: 20, percent_discount: 0.20, name:'Halloween Discount', merchant_id: @merchant1.id)
  end

  describe "when I visit my merchant dashboard" do
    it "can see a link to view all discounts and when I click this link, I  am taken to my bulk discounts index page" do
      VCR.use_cassette("nager_data_service_next_public_holidays") do
        visit merchant_dashboard_index_path(@merchant1)

        within(".nav-container") do
          expect(page).to have_link("My Discounts")
          click_link("My Discounts")
        end

        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
      end
    end


    it "can display all of a merchant's bulk discounts including percentage discount and quantity thresholds" do
      VCR.use_cassette("nager_data_service_next_public_holidays") do
        visit merchant_bulk_discounts_path(@merchant1)

        @merchant1.bulk_discounts.each do |bulk_discount|
          within(".bulk-discount-info-#{bulk_discount.id}") do
            expect(page).to have_content(bulk_discount.name)
            expect(page).to have_content(bulk_discount.percent_discount)
            expect(page).to have_content(bulk_discount.item_threshold)
          end
        end
      end
    end

    it "has a link next to each bulk discount listed that links to its show page" do
      VCR.use_cassette("nager_data_service_next_public_holidays") do
        visit merchant_bulk_discounts_path(@merchant1)

        within(".bulk-discount-info-#{@bulk_discount_1.id}") do
          expect(page).to have_link("#{@bulk_discount_1.id}")
        end

        within(".bulk-discount-info-#{@bulk_discount_2.id}") do
          expect(page).to have_link("#{@bulk_discount_2.id}")
        end

        within(".bulk-discount-info-#{@bulk_discount_3.id}") do
          expect(page).to have_link("#{@bulk_discount_3.id}")
        end
      end
    end

    it "has a section for 'Upcoming Holidays' that lists the next three upcoming US holidays" do
      VCR.use_cassette("nager_data_service_next_public_holidays") do
        visit merchant_bulk_discounts_path(@merchant1)

        expect(page).to have_content("Upcoming Holidays")
        expect(page).to have_content("Memorial Day")
        expect(page).to have_content("Independence Day")
        expect(page).to have_content("Labor Day")
      end
    end
  end
end

# As a merchant
# When I visit the discounts index page
# I see a section with a header of "Upcoming Holidays"
# In this section the name and date of the next 3 upcoming US holidays are listed.
#
# Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)
