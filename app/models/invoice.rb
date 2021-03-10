class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :complete]

  def total_revenue
    invoice_items.sum(&:revenue)
  end

  def total_revenue_without_discounts
    invoice_items.sum("unit_price * quantity")
  end

  def discount_savings
    total_revenue_without_discounts - total_revenue
  end
end
