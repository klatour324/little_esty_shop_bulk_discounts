require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end

  describe "different statuses" do
    before :each do
      @customer1 = Customer.create(first_name: "Joe",
                                   last_name: "Smith")
      @invoice1 = @customer1.invoices.create(status: 0)
      @invoice2 = @customer1.invoices.create(status: 1)
      @invoice3 = @customer1.invoices.create(status: 2)
      @invoice4 = @customer1.invoices.create(status: 0)

      @merchant = Merchant.create(name: "John's Jewelry")
      @item1 = @merchant.items.create(name: "Gold Ring", description: "14K Wedding Band",
                                      unit_price: 599.95)
      @item2 = @merchant.items.create(name: "Diamond Ring", description: "Shiny",
                                      unit_price: 1000.00)
      @item3 = @merchant.items.create(name: "Silver Ring", description: "Plain",
                                      unit_price: 350.00)
      @item4 = @merchant.items.create(name: "Mood Ring", description: "Strong mood vibes",
                                      unit_price: 100.00)
      @invoice_item1 = InvoiceItem.create!(invoice_id: @invoice1.id,
                                           item_id: @item1.id, quantity: 500,
                                           unit_price: 599.95, status: 0)
      @invoice_item2 = InvoiceItem.create!(invoice_id: @invoice2.id,
                                           item_id: @item2.id, quantity: 200,
                                           unit_price: 1000.00, status: 0)
      @invoice_item3 = InvoiceItem.create!(invoice_id: @invoice3.id,
                                           item_id: @item1.id, quantity: 100,
                                           unit_price: 350.00, status: 0)
      @invoice_item4 = InvoiceItem.create!(invoice_id: @invoice4.id,
                                           item_id: @item4.id, quantity: 400,
                                           unit_price: 100.00, status: 0)
    end
    it 'can display in progress' do
      expect(@invoice1.status).to eq("cancelled")
      expect(@invoice1.status).to_not eq("in_progress")
      expect(@invoice1.status).to_not eq("complete")
    end

    it 'can display completed' do
      expect(@invoice2.status).to eq("in_progress")
      expect(@invoice2.status).to_not eq("cancelled")
      expect(@invoice2.status).to_not eq("complete")
    end

    it 'can display cancelled' do
      expect(@invoice3.status).to eq("complete")
      expect(@invoice3.status).to_not eq("cancelled")
      expect(@invoice3.status).to_not eq("in_progress")
    end
  end

  describe "instance methods" do
    describe "#total_revenue_without_discounts" do
      it "returns the revenue of all invoice items regardless of bulk discounts applied" do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 20, unit_price: 10, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 10, status: 2)
        bulk_discount1 = merchant1.bulk_discounts.create!(name: "Blowout Sale!", item_threshold: 20, percent_discount: 10)

        expect(invoice_1.total_revenue_without_discounts).to eq(250)
      end
    end

    describe "#total_revenue" do
      it "returns the revenue of all invoice items with bulk discount is applied" do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 20, unit_price: 10, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 10, status: 2)
        bulk_discount1 = merchant1.bulk_discounts.create!(name: "Blowout Sale!", item_threshold: 20, percent_discount: 10)

        expect(invoice_1.total_revenue).to eq(230)
      end
    end

    describe "#discount_savings" do
      it "returns the savings from bulk discounts applied" do
        merchant1 = Merchant.create!(name: 'Hair Care')
        item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id, status: 1)
        customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 20, unit_price: 10, status: 2)
        ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 5, unit_price: 10, status: 2)
        bulk_discount1 = merchant1.bulk_discounts.create!(name: "Blowout Sale!", item_threshold: 20, percent_discount: 10)

        expect(invoice_1.discount_savings).to eq(20)
      end
    end
  end
end
