class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  validates_presence_of :item_threshold, :percent_discount, :name
  validates_numericality_of :item_threshold, :greater_than => 1
  validates_numericality_of :percent_discount, :greater_than => 0, :less_than => 1
end
