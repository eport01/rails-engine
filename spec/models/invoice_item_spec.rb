require 'rails_helper'

RSpec.describe InvoiceItem do 
  describe 'relationships' do 
    it { should belong_to :invoice }
    it { should belong_to :item }
    it {should have_one(:merchant).through(:item)}
  end
end