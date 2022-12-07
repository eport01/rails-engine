class Merchant < ApplicationRecord
  has_many :items 
  has_many :invoices, through: :items 
  has_many :invoice_items, through: :invoices
end
