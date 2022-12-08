require 'rails_helper'
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