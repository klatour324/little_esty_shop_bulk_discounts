require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchant) }
  end

  describe "instance methods" do
    describe "#available discount" do
      describe "Invoice A has two items, Item A with quantity of 5, Item B with quantity of 5. Merchant A has Bulk Discount A, 20% off 10 items." do
        it "does not apply available discount when an invoice's item does not meet the bulk discount item threshold (quantity 10 for each item)" do
          merchant = Merchant.create!(name: 'Hair Care')
          item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, status: 1)
          item_2 = Item.create!(name: "Conditioner", description: "This conditions your hair", unit_price: 20, merchant_id: merchant.id, status: 1)
          customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
          invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
          ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 1, status: 2)
          ii_4 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 5, unit_price: 1, status: 2)
          bulk_discount2 = merchant.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 0.20)

          expect(ii_3.available_discount).to eq(nil)
          expect(ii_4.available_discount).to eq(nil)
        end
      end

      describe "Invoice A has two items, Item A with quantity of 10, Item B with quantity of 5. Merchant A has Bulk Discount A, 20% off 10 items." do
        it "Applies 20% off discount to item A, item B receives no discount" do
          merchant = Merchant.create!(name: 'Hair Care')
          item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, status: 1)
          item_2 = Item.create!(name: "Conditioner", description: "This conditions your hair", unit_price: 20, merchant_id: merchant.id, status: 1)
          customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
          invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
          ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 10, unit_price: 1, status: 2)
          ii_4 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 5, unit_price: 1, status: 2)
          bulk_discount2 = merchant.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 0.20)

          expect(ii_3.available_discount.percent_discount).to eq(bulk_discount2.percent_discount)
          expect(ii_4.available_discount).to eq(nil)
        end
      end

      describe "Invoice A has two items, Item A with quantity of 12, Item B with quantity of 15. Merchant A has two Bulk Discount A 20% off 10 items, Bulk Discount B 30% 15 items." do
        it "Applies 20% off discount to Item A, applies 30% off bulk discount to Item B" do
          merchant = Merchant.create!(name: 'Hair Care')
          item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, status: 1)
          item_2 = Item.create!(name: "Conditioner", description: "This conditions your hair", unit_price: 20, merchant_id: merchant.id, status: 1)
          customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
          invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
          ii_6 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 12, unit_price: 1, status: 2)
          ii_7 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 15, unit_price: 1, status: 2)
          bulk_discount2 = merchant.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 0.20)
          bulk_discount3 = merchant.bulk_discounts.create!(name: "Fall Discount", item_threshold: 15, percent_discount: 0.30)

          expect(ii_6.available_discount.percent_discount).to eq(bulk_discount2.percent_discount)
          expect(ii_7.available_discount.percent_discount).to eq(bulk_discount3.percent_discount)
        end
      end

      describe "Invoice A has two items, Item A with quantity of 12, Item B with quantity of 15. Merchant A has two Bulk Discount A 20% off 10 items, Bulk Discount B 15% off 15 items." do
        it "Applies 20% off discount to both Item A and Item B, 15% off bulk discount will never apply" do
          merchant = Merchant.create!(name: 'Hair Care')
          item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, status: 1)
          item_2 = Item.create!(name: "Conditioner", description: "This conditions your hair", unit_price: 20, merchant_id: merchant.id, status: 1)
          customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
          invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
          ii_6 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 12, unit_price: 1, status: 2)
          ii_7 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 15, unit_price: 1, status: 2)
          bulk_discount2 = merchant.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 0.20)
          bulk_discount6 = merchant.bulk_discounts.create!(name: "Bonanaza Closeout Discount!", item_threshold: 15, percent_discount: 0.15)

          expect(ii_6.available_discount.percent_discount).to eq(bulk_discount2.percent_discount)
          expect(ii_7.available_discount.percent_discount).to eq(bulk_discount2.percent_discount)
          expect(ii_6.available_discount.percent_discount).to_not eq(bulk_discount6.percent_discount)
          expect(ii_7.available_discount.percent_discount).to_not eq(bulk_discount6.percent_discount)
        end
      end

      describe "Invoice A has two items, Item A1 with quantity of 12, Item A2 with quantity of 15 which belong to Merchant A." do
        describe "Invoice A also has Merchant B's item with quantity of 15. Merchant A has two bulk discounts:" do
          describe "Bulk Discount A is 20% off 10 items, Bulk Discount B is 30% off 15 items. Merchant B has no bulk discounts" do
            it "Applies 20% off discount to Item A1 and 30% off to Item A2. Item B will not be discounted" do
              merchant = Merchant.create!(name: 'Hair Care')
              merchant1 = Merchant.create!(name: "Suds n' Stuff")
              item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant.id, status: 1)
              item_2 = Item.create!(name: "Conditioner", description: "This conditions your hair", unit_price: 20, merchant_id: merchant.id, status: 1)
              item_3 = Item.create!(name: "Body Wash", description: "This conditions your body", unit_price: 15, merchant_id: merchant1.id, status: 1)
              customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
              invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
              ii_6 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 12, unit_price: 1, status: 2)
              ii_7 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 15, unit_price: 1, status: 2)
              ii_8 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_3.id, quantity: 15, unit_price: 1, status: 2)
              bulk_discount2 = merchant.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 0.20)
              bulk_discount3 = merchant.bulk_discounts.create!(name: "Fall Discount", item_threshold: 15, percent_discount: 0.30)

              expect(ii_6.available_discount.percent_discount).to eq(bulk_discount2.percent_discount)
              expect(ii_7.available_discount.percent_discount).to eq(bulk_discount3.percent_discount)
              expect(ii_8.available_discount).to eq(nil)
            end
          end
        end
      end
    end

    describe "#revenue" do
      it "returns the revenue of an invoice item when a bulk discount is applied" do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 20, unit_price: 1, status: 2)
        bulk_discount5 = merchant1.bulk_discounts.create!(name: "Blowout Sale!", item_threshold: 20, percent_discount: 0.40)
        bulk_discount1 = merchant1.bulk_discounts.create!(name: "Big Box Sale!", item_threshold: 20, percent_discount: 0.20)

        expect(ii_1.revenue).to eq(12)
        expect(ii_1.revenue).to_not eq(16)
      end
    end

    it "returns the revenue of an invoice item with no bulk discount applied" do
      merchant1 = Merchant.create!(name: 'Hair Care')
      item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
      customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      ii_3 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 1, status: 2)

      expect(ii_3.revenue).to eq(5)
      expect(ii_3.revenue).to_not eq(4)
    end
  end
end
