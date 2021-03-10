require "rails_helper"

RSpec.describe "Merchant Bulk Discount Delete" do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @bulk_discount_1 = BulkDiscount.create!(item_threshold: 5, percent_discount: 5, name:'Senior Day Discount', merchant_id: @merchant1.id)
    @bulk_discount_2 = BulkDiscount.create!(item_threshold: 10, percent_discount: 10, name:'Christmas Discount', merchant_id: @merchant1.id)
    @bulk_discount_3 = BulkDiscount.create!(item_threshold: 15, percent_discount: 15, name:' 4th of July Discount', merchant_id: @merchant1.id)
    @bulk_discount_4 = BulkDiscount.create!(item_threshold: 20, percent_discount: 20, name:'Halloween Discount', merchant_id: @merchant1.id)
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
          expect(page).to have_link("Delete Bulk Discount")
        end

        within(".bulk-discount-info-#{bd_2.id}") do
          expect(page).to_not have_link("Delete Bulk Discount")
          expect(page).to have_content("Can't Delete due to Pending Invoices")
        end
      end
    end
  end
end
