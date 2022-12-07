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

    merchant_id = create(:merchant).id 

    item_params = {
      name: 'Chocolate',
      description: 'Yummy!',
      unit_price: 3.50,
      merchant_id: merchant_id
    }

    headers = {"CONTENT_TYPE" => "application/json"} 

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    item = Item.last 
    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
    expect(item.description).to eq(item_params[:description])
    expect(item.unit_price).to eq(item_params[:unit_price])
    expect(item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "can update an existing item" do 
    item = create(:item)
    previous_name = Item.last.name 

    item_params = {
      name: "More Chocolate",
      description: item.description,
      unit_price: item.unit_price,
      merchant_id: item.merchant_id
    }
    
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

    item = Item.find_by(id: item.id)
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("More Chocolate")
  end


  it "can destroy an item" do 
    item = create(:item)
    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns a 404 response if no item is found' do 

  end

  it 'can return an items merchant based on an item id' do 
    merchant = create(:merchant) 
    create_list(:item, 3, merchant: merchant)
    item = Item.last 
    get "/api/v1/items/#{item.id}/merchant"

    items_merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(items_merchant).to have_key(:id)
    expect(items_merchant[:id].to_i).to eq(merchant.id)
    expect(items_merchant[:attributes]).to have_key(:name)
    expect(items_merchant[:attributes][:name]).to be_a(String)
  end

  

end