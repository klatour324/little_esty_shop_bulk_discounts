require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Index" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = BulkDiscount.create!(item_threshold: 5, percent_discount: 5, name:'Senior Day Discount', merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(item_threshold: 10, percent_discount: 10, name:'Christmas Discount', merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(item_threshold: 15, percent_discount: 15, name:' 4th of July Discount', merchant_id: @merchant1.id)
    @bulk_discount_4 = BulkDiscount.create!(item_threshold: 20, percent_discount: 20, name:'Halloween Discount', merchant_id: @merchant1.id)
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
        expect(page).to have_content("2021-05-31")
        expect(page).to have_content("Independence Day")
        expect(page).to have_content("2021-07-05")
        expect(page).to have_content("Labor Day")
        expect(page).to have_content("2021-09-06")
      end
    end

    it "does not display a delete button next to bulk discounts with pending invoice items" do
      VCR.use_cassette("bulk_discount_creation") do
        m1 = Merchant.create!(name: 'Hair Care')

        bd_1 = m1.bulk_discounts.create!(name: "Big Box Sale!", item_threshold: 20, percent_discount: 20)
        bd_2 = m1.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 10)
        bd_3 = m1.bulk_discounts.create!(name: "Fall Discount", item_threshold: 30, percent_discount: 30)

        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: m1.id, status: 1)
        item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: m1.id)
        item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: m1.id)

        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 1, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 2, status: 0)
        ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 25, unit_price: 3, status: 2)

        visit "/merchant/#{m1.id}/bulk_discounts"

        within(".bulk-discount-info-#{bd_1.id}") do
          expect(page).to have_button("Delete Bulk Discount")
        end

        within(".bulk-discount-info-#{bd_2.id}") do
          expect(page).to_not have_button("Delete Bulk Discount")
          expect(page).to have_content("Can't Delete due to Pending Invoices")
        end
      end
    end
  end
end
