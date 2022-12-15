class Merchant < ApplicationRecord
  has_many :items 
  has_many :invoices, through: :items 
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices 


  def self.find_by_name(name)
    Merchant.where("name ILIKE ?", "%#{name}%").order(:name)[0]
  end

  def self.top_merchants_by_revenue(quantity)
    #join invoice_items, transactions, invoices 
    # Merchant.joins(invoices: :invoice_items) 
    #merchant join to invoices, invoice join to invoice items
    # Merchant.joins(:invoices, :invoice_items)
    #merchant join to invoices and then merchant join to invoice_items
    Merchant.joins(invoices: [:invoice_items, :transactions])
            .where(invoices: {status: "shipped"})
            .select(:name, :id, 'SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')
            .group(:id)
            .order(revenue: :desc)
            .limit(quantity)
  end
end
