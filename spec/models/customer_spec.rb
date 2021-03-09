require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end
  describe "relationships" do
    it { should have_many :invoices }
    it { should have_many(:merchants).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  # describe "class methods" do
  #   describe "::top_customers" do
  #     it "returns top five customers with successful transactions" do
  #       @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
  #       @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
  #       @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
  #       @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
  #       @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
  #       @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')
  #
  #       @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
  #       @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
  #       @invoice_3 = Invoice.create!(customer_id: @customer_1.id, status: 2)
  #       @invoice_4 = Invoice.create!(customer_id: @customer_1.id, status: 2)
  #       @invoice_5 = Invoice.create!(customer_id: @customer_6.id, status: 2)
  #       @invoice_6 = Invoice.create!(customer_id: @customer_6.id, status: 2)
  #       @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)
  #       @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)
  #       @invoice_9 = Invoice.create!(customer_id: @customer_2.id, status: 2)
  #       @invoice_10 = Invoice.create!(customer_id: @customer_2.id, status: 2)
  #       @invoice_11 = Invoice.create!(customer_id: @customer_3.id, status: 2)
  #       @invoice_12 = Invoice.create!(customer_id: @customer_3.id, status: 2)
  #       @invoice_13 = Invoice.create!(customer_id: @customer_4.id, status: 2)
  #
  #       @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
  #       @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
  #       @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
  #       @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
  #       @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
  #       @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
  #       @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
  #
  #       expect(Customer.top_customers).to eq([@customer_1, @customer_6, @customer_2, @customer_3, @customer_4])
  #     end
  #   end
  # end
end
