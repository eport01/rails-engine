class Item < ApplicationRecord
  belongs_to :merchant 
  has_many :invoice_items, dependent: :destroy  
  has_many :invoices, through: :invoice_items
  after_destroy :destroy_empty_invoices


  def destroy_empty_invoices 
    # require 'pry'; binding.pry
    # invoices.joins(:invoice_items).where("invoice_items.item_id = ?", self.id)
    Invoice.all.each do |invoice|
      if invoice.invoice_items == []
        invoice.destroy 

      end
    end

    # x = invoice_items.where("invoice_items.item_id = ?", self.id)
    # require 'pry'; binding.pry
    

    # x.each do |invoice_item|
    #   invoice_item.invoice.destroy 
    # end
    
    
    # invoices.each do |invoice| 
    #   # require 'pry'; binding.pry
    #   invoice.destroy
  
    # end

  end


end