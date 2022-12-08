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

  def items_above_price(min_price) 
    Item.where("unit_price < ?", "#{min_price}}")  
    require 'pry'; binding.pry
  end

  def items_below_price(max_price)

  end


end