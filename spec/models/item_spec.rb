require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do 

  end

  before :each do 
    merchant = create(:merchant) 
    @item1 = create(:item)
    @item2 = create(:item)


    @emily = Customer.create!(first_name: "Emily", last_name: "Port")
    @invoice1 = Invoice.create!(merchant_id: merchant.id, status: 1, customer_id: @emily.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice2 = Invoice.create!(merchant_id: merchant.id, status: 1, customer_id: @emily.id, created_at: "2022-11-02 11:00:00 UTC")
    @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item1.id, invoice_id: @invoice1.id)
    @invoice_item2 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item1.id, invoice_id: @invoice2.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item2.id, invoice_id: @invoice2.id)
  end

  it 'can find all of the invoices with this item' do 
    require 'pry'; binding.pry
  end
end
