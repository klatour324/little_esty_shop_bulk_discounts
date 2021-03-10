require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount1 = @merchant1.bulk_discounts.create!(name: "Big Box Sale!", item_threshold: 20, percent_discount: 20)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 10)
    @bulk_discount3 = @merchant1.bulk_discounts.create!(name: "Fall Discount", item_threshold: 30, percent_discount: 30)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 1, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 15, unit_price: 2, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_3.id, quantity: 25, unit_price: 3, status: 2)

  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many(:items).through(:merchant)}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe "validations" do
    it { should validate_presence_of(:item_threshold) }
    it { should validate_numericality_of(:item_threshold) }
    it { should validate_presence_of(:percent_discount) }
    it { should validate_numericality_of(:percent_discount).is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:percent_discount).is_less_than_or_equal_to(100) }
    it { should validate_presence_of(:name) }
  end

  describe "instance method" do
    describe "#pending_invoice_items?" do
      it "can return true for any pending invoices in a given bulk discount" do

        expect(@bulk_discount2.pending_invoice_items?).to eq(true)
      end

      it "can return false when no discount applies to any items" do

        expect(@bulk_discount3.pending_invoice_items?).to eq(false)
      end

      it "can return false when a discount does apply and no pending invoice items" do

        expect(@bulk_discount1.pending_invoice_items?).to eq(false)
      end
    end
  end
end
