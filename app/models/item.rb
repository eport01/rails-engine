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



end