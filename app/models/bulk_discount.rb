class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :item_threshold, :percent_discount, :name
  validates_numericality_of :item_threshold, :greater_than => 1
  validates_numericality_of :percent_discount, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100


  def pending_invoice_items?
    invoice_items
    .where(status: :pending)
    .where("quantity >= ?", item_threshold)
    .any?
  end
end
