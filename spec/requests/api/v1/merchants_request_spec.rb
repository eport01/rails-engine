require 'rails_helper'

describe "Merchants API endpoints" do
  describe 'api/v1/merchants' do 
    it "sends a list of all merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchants.count).to eq(3)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id].to_i).to be_an(Integer)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe 'api/v1/merchants/:merchant_id' do 
    it "can get one merchant by its id" do 
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"
    
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    
      expect(response).to be_successful
    
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to eq(id)
    
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

    it 'sad path, bad integer id returns status 404' do 
      get "/api/v1/merchants/34"

      expect(response).to have_http_status 404

    end
  end

  describe '/api/v1/merchants/merchant_id/items' do 

    it "can get all items for a given merchant ID" do 
      merchant = create(:merchant) 
      create_list(:item, 3, merchant: merchant)
      get "/api/v1/merchants/#{merchant.id}/items"
      merchant_items = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(merchant_items.count).to eq(3)
      merchant_items.each do |item|
        # require 'pry'; binding.pry
        expect(item).to have_key(:id)
        expect(item[:id].to_i).to be_an(Integer)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)

      end
    end

    it 'sad path, bad integer id returns 404' do 
      create_list(:item, 3)
      get "/api/v1/merchants/300/items"
      expect(response).to have_http_status 404

    end
  end

  describe "non-RESTful search endpoints to find one merchant" do 
    it 'find a single merchant which matches a search term' do 
      
      create_list(:merchant, 3)
      get "/api/v1/merchants/find?name=#{Merchant.first.name}"
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(response).to be_successful
    
      expect(merchant).to have_key(:id)
      expect(merchant[:id].to_i).to eq(Merchant.first.id)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to eq(Merchant.first.name)
    end

    it 'returns an empty object and status 200 if no fragment matched' do 
      merchant = Merchant.create!(name: 'Steve')
      get "/api/v1/merchants/find?name=#{'jim'}"
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to have_http_status 200

      expect(merchant[:id]).to eq(nil)
    end
  end
end