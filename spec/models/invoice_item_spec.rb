require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @bulk_discount1 = @merchant1.bulk_discounts.create!(name: "Big Box Sale!", item_threshold: 20, percent_discount: 0.20)
    @bulk_discount2 = @merchant1.bulk_discounts.create!(name: "Semi-Annual Discount", item_threshold: 10, percent_discount: 0.10)
    @bulk_discount3 = @merchant1.bulk_discounts.create!(name: "Fall Discount", item_threshold: 30, percent_discount: 0.30)
    @bulk_discount4 = @merchant1.bulk_discounts.create!(name: "Last Call Discount", item_threshold: 40, percent_discount: 0.40)
    @bulk_discount5 = @merchant1.bulk_discounts.create!(name: "Blowout Sale!", item_threshold: 20, percent_discount: 0.40)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 20, unit_price: 1, status: 2)

  end

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
    it "#available discount" do
      expect(@ii_1.available_discount).to eq(@bulk_discount5)
      expect(@ii_1.available_discount).to_not eq(@bulk_discount1)
    end

    it "#revenue" do
      expect(@ii_1.revenue).to eq(12)
      expect(@ii_1.revenue).to_not eq(16)
    end
  end
end
