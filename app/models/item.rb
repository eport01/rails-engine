class Item < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items, dependent: :destroy  
  has_many :invoices, through: :invoice_items
  after_destroy :destroy_empty_invoices

  def destroy_empty_invoices 
    Invoice.all.each do |invoice|
      if invoice.invoice_items == []
        invoice.destroy 
      end
    end
  end

  def self.below(max_price)
    Item.where("unit_price < ?", "#{max_price}")
  end

  def self.above(min_price)
    Item.where("unit_price > ?", "#{min_price}")
  end

  def self.find_by_name(name)
    Item.where("name ILIKE ?", "%#{name}%")
  end

end