class Merchant < ApplicationRecord
  has_many :items 
  has_many :invoices, through: :items 
  has_many :invoice_items, through: :invoices


  def self.find_by_name(name)
    Merchant.where("name ILIKE ?", "%#{name}%").order(:name)[0]
  end
end
