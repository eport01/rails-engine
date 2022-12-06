require 'rails_helper' 

describe "Items API endpoints" do 
  it "sends a list of all items " do 
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id].to_i).to be_an(Integer)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it "can get one item by its id" do 
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    # require 'pry'; binding.pry

    expect(item).to have_key(:id)
    expect(item[:id].to_i).to eq(id)
  
    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_a(Integer)

  end

  it "can create an item" do 

    # create_list(:item, 3)

    # get '/api/v1/items'
    merchant_id = create(:merchant).id 

    item_params = {
      name: 'Chocolate',
      description: 'Yummy!',
      unit_price: 3.50,
      merchant_id: merchant_id
    }

    # created_item = create(:item)
    # item_params = attributes_for(:item)
    # item = build(:item, merchant: merchant)
    headers = {"CONTENT_TYPE" => "application/json"} 
    # require 'pry'; binding.pry

    # item = create(:item)
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    item = Item.last 
    # require 'pry'; binding.pry
    expect(response).to be_successful


    expect(item.name).to eq(item_params[:name])
    expect(item.description).to eq(item_params[:description])
    expect(item.unit_price).to eq(item_params[:unit_price])
    expect(item.merchant_id).to eq(item_params[:merchant_id])

  end
end