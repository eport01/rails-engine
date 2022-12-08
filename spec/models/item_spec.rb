require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do 
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }

  end

  before :each do 
    merchant = create(:merchant) 
    @item1 = create(:item, unit_price: 30, name: "Chocolate")
    @item2 = create(:item, unit_price: 100, name: "Reeses")

    @emily = Customer.create!(first_name: "Emily", last_name: "Port")
    @invoice1 = Invoice.create!(merchant_id: merchant.id, status: 1, customer_id: @emily.id, created_at: "2022-11-01 11:00:00 UTC")
    @invoice2 = Invoice.create!(merchant_id: merchant.id, status: 1, customer_id: @emily.id, created_at: "2022-11-02 11:00:00 UTC")

    @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item1.id, invoice_id: @invoice1.id)
    @invoice_item2 = InvoiceItem.create!(quantity: 1, unit_price: 500, item_id: @item1.id, invoice_id: @invoice2.id)
    @invoice_item3 = InvoiceItem.create!(quantity: 1, unit_price: 150, item_id: @item2.id, invoice_id: @invoice2.id)
  end

  it 'returns items below a max price' do 
    expect(Item.below(50).first).to eq(@item1)
  end

  it 'returns items above a min price' do 
    expect(Item.above(50).first).to eq(@item2)
  end

  it 'returns item by name' do 
    expect(Item.find_by_name("Reeses").first).to eq(@item2)
  end

  it 'destroys empty invoices' do 
    merchant = create(:merchant) 
    @invoice3 = Invoice.create!(merchant_id: merchant.id, status: 1, customer_id: @emily.id, created_at: "2022-11-02 11:00:00 UTC")

    @invoice_item4 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item1.id, invoice_id: @invoice3.id)
    expect(@invoice3.items).to eq([@item1])
    @item1.destroy 

    expect(Invoice.all).to_not eq(@invoice3)
  end
end
