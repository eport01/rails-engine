require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do 
    it { should have_many :items }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:invoice_items).through(:invoices) }
  end

  it 'can find a merchant by name' do 
    louie = create(:merchant, name: "Louie")
    zoe = create(:merchant, name: "Zoe")
    expect(Merchant.find_by_name("Louie")).to eq(louie)
    expect(Merchant.find_by_name("Zoe")).to_not eq(louie)
  end
end
