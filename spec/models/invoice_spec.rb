require 'rails_helper' 

RSpec.describe Invoice do 
  describe 'relationships' do
    it { should have_many :invoice_items }
    it { should belong_to :customer }

    it { should have_many(:items).through(:invoice_items) }
  end 
end