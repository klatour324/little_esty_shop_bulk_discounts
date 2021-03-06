require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many(:items).through(:merchant)}
    it {should have_many(:invoice_items).through(:items)}
  end

  describe "validations" do
    it { should validate_presence_of(:item_threshold) }
    it { should validate_numericality_of(:item_threshold) }
    it { should validate_presence_of(:percent_discount) }
    it { should validate_numericality_of(:percent_discount) }
    it { should validate_presence_of(:name) }

    it " only returns records that have an item threshold greater than 1" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @bulk_discount_1 = BulkDiscount.new(item_threshold: 0,
                                          percent_discount: 0.05,
                                          name:'Senior Day Discount',
                                          merchant_id: @merchant1.id)
      @bulk_discount_2 = BulkDiscount.new(item_threshold: 1,
                                          percent_discount: 0.10,
                                          name:'Christmas Discount',
                                          merchant_id: @merchant1.id)
      @bulk_discount_3 = BulkDiscount.new(item_threshold: 15,
                                          percent_discount: 0.15,
                                          name:' 4th of July Discount',
                                          merchant_id: @merchant1.id)

      expect(@bulk_discount_1.save).to eq(false)
      expect(@bulk_discount_2.save).to eq(false)
      expect(@bulk_discount_3.save).to eq(true)
    end

    it "only returns records that have an percent discount between 0.0 and 1.0" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @bulk_discount_1 = BulkDiscount.new(item_threshold: 0,
                                          percent_discount: 0.0,
                                          name:'Senior Day Discount',
                                          merchant_id: @merchant1.id)
      @bulk_discount_2 = BulkDiscount.new(item_threshold: 10,
                                          percent_discount: 0.10,
                                          name:'Christmas Discount',
                                          merchant_id: @merchant1.id)
      @bulk_discount_3 = BulkDiscount.new(item_threshold: 15,
                                          percent_discount: 1.0,
                                          name:' 4th of July Discount',
                                          merchant_id: @merchant1.id)

      expect(@bulk_discount_1.save).to eq(false)
      expect(@bulk_discount_2.save).to eq(true)
      expect(@bulk_discount_3.save).to eq(false)
    end
  end
end
