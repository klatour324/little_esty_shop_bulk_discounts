class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def available_discount
    item
    .merchant
    .bulk_discounts
    .order(percent_discount: :desc)
    .order(item_threshold: :desc)
    .where('item_threshold <= ?', "#{self.quantity}")
    .first
  end

  def revenue
    invoice_item_revenue = unit_price * quantity
    if available_discount.nil?
      invoice_item_revenue
    else
      discount = invoice_item_revenue * (( 100 - available_discount.percent_discount.to_f) / 100)
      discount
    end
  end
end
