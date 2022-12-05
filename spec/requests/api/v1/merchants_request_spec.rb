require 'rails_helper'

describe "Merchants API endpoints" do
  it "sends a list of all merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    # require 'pry'; binding.pry
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
    id = create(:merchant).id 
    get "/api/v1/merchants/#{id}/items"
    # require 'pry'; binding.pry

  end
end