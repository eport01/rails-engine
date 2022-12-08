require 'rails_helper'
describe 'unrestful routes, find all items by name fragment' do 
  it 'returns all items through search criteria' do 
    item1 = create(:item, name: 'chocolate')
    item2 = create(:item, name: 'dark chocolate')
    item3 = create(:item, name: 'milk chocolate')
    item4 = create(:item, name: 'jolly ranchers')

    get "/api/v1/items/find_all?name=#{"chocolate"}"

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful
    expect(items.count).to eq(3)
    items.each do |item|
      expect(item[:id].to_i).to be_an(Integer)
      expect(item[:attributes][:name]).to be_an(String)
      expect(item[:attributes][:description]).to be_an(String)
      expect(item[:attributes][:unit_price]).to be_an(Float)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)

      expect(item).to_not eq(item4)
    end
  end

  it 'returns an empty array and status 200 if no fragment matched' do 
    item1 = create(:item, name: 'chocolate')
    get "/api/v1/items/find_all?name=#{"j"}"
    item = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status 200
    expect(item[:data]).to eq([])

  end
end
describe 'find all items by min price' do 
  
  it 'can find all items based on a min price' do 
    item1 = create(:item, unit_price: 15.50)
    item2 = create(:item, unit_price: 30.00)
    item3 = create(:item, unit_price: 3.50)

    get "/api/v1/items/find_all?min_price=#{5.00}"
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    items.each do |item|
      expect(item[:id].to_i).to be_an(Integer)
      expect(item[:attributes][:name]).to be_an(String)
      expect(item[:attributes][:description]).to be_an(String)
      expect(item[:attributes][:unit_price]).to be_an(Float)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)

      expect(item).to_not eq(item3)
    end
  end

  it 'sad path, min price cant be less than 0' do 
    item1 = create(:item, unit_price: 15.50)
    item2 = create(:item, unit_price: 30.00)
    item3 = create(:item, unit_price: 3.50)

    get "/api/v1/items/find_all?min_price=#{-5}"
    expect(response).to have_http_status 400
  end

  it 'sad path, cannot send name and min price' do 
    item1 = create(:item, unit_price: 15.50)
    item2 = create(:item, unit_price: 30.00)
    item3 = create(:item, unit_price: 3.50)

    get "/api/v1/items/find_all?name=#{item1.name}&min_price=#{5.00}"
    expect(response).to have_http_status 400
  end
end

describe 'find all items by max price' do 
  it 'can find all items based on a min price' do 
    item1 = create(:item, unit_price: 15.50)
    item2 = create(:item, unit_price: 30.00)
    item3 = create(:item, unit_price: 3.50)

    get "/api/v1/items/find_all?max_price=#{20.00}"
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    items.each do |item|
      expect(item[:id].to_i).to be_an(Integer)
      expect(item[:attributes][:name]).to be_an(String)
      expect(item[:attributes][:description]).to be_an(String)
      expect(item[:attributes][:unit_price]).to be_an(Float)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)

      expect(item).to_not eq(item2)
    end
  end

  it 'sad path, max price cant be less than 0' do 
    item1 = create(:item, unit_price: 15.50)
    item2 = create(:item, unit_price: 30.00)
    item3 = create(:item, unit_price: 3.50)

    get "/api/v1/items/find_all?min_price=#{-5}"
    expect(response).to have_http_status 400
  end

  it 'sad path, cannot send name and max price' do 
    item1 = create(:item, unit_price: 15.50)
    item2 = create(:item, unit_price: 30.00)
    item3 = create(:item, unit_price: 3.50)

    get "/api/v1/items/find_all?name=#{item1.name}&max_price=#{5.00}"
    expect(response).to have_http_status 400
  end
end
