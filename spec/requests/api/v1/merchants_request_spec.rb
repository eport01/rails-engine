require 'rails_helper'

describe "Merchants API endpoints" do
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
end