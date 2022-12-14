require 'rails_helper' 

describe "Items API endpoints" do 
  describe 'get /api/v1/items' do 
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
  end

  describe 'get /api/v1/items/item_id' do 
    it "can get one item by its id" do 
      id = create(:item).id

      get "/api/v1/items/#{id}"
      # require 'pry'; binding.pry
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

    it 'edge case, string id converted to integer' do 
      get "/api/v1/items/3"
      expect(response).to have_http_status 404
      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors[:error]).to eq("bad item id")

    end
  end

  describe 'post /api/v1/items' do 
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
  end 

  describe 'put /api/v1/items/item_id' do
    it "can update an existing item by id" do 
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

    it 'it works with only partial data too' do 
      item = create(:item)
      previous_name = Item.last.name 

      item_params = {
        name: "More Chocolate",
      }
      
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({item: item_params})

      item = Item.find_by(id: item.id)
      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("More Chocolate")
    end

    it 'edge case, string id returns a 404' do 
      put "/api/v1/items/#{"pizza"}"
      expect(response).to have_http_status 404
      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors[:error]).to eq("unable to update")
    end

    it 'sad path, bad integer id returns 404' do 
      put "/api/v1/items/3"
      expect(response).to have_http_status 404
      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors[:error]).to eq("unable to update")
    end
  end

  describe 'destroy api/v1/items/item_id' do 
    it "can destroy an item" do 
      item = create(:item)
      expect(Item.count).to eq(1)

      delete "/api/v1/items/#{item.id}"

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "destroys any invoice if the deleted item was the only item on that invoice" do 
      merchant = create(:merchant) 
      @item1 = create(:item)
      @item2 = create(:item)
  
  
      @emily = Customer.create!(first_name: "Emily", last_name: "Port")
      @invoice1 = Invoice.create!(merchant_id: merchant.id, status: 1, customer_id: @emily.id, created_at: "2022-11-01 11:00:00 UTC")
      @invoice2 = Invoice.create!(merchant_id: merchant.id, status: 1, customer_id: @emily.id, created_at: "2022-11-02 11:00:00 UTC")
      @invoice_item1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item1.id, invoice_id: @invoice1.id)
      @invoice_item2 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item1.id, invoice_id: @invoice2.id)
      @invoice_item3 = InvoiceItem.create!(quantity: 1, unit_price: 5000, item_id: @item2.id, invoice_id: @invoice2.id)
      
      expect(Item.count).to eq(2)
      expect(@invoice1.items).to eq([@item1])
      expect(@invoice2.items).to eq([@item1, @item2])
  
  
      delete "/api/v1/items/#{@item1.id}"
  
      expect{Item.find(@item1.id)}.to raise_error(ActiveRecord::RecordNotFound)
  
      expect{Invoice.find(@invoice1.id)}.to raise_error(ActiveRecord::RecordNotFound)
  
    end

    it 'returns 404 status if bad id' do 
      delete "/api/v1/items/3"
      expect(response).to have_http_status 404
      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors[:error]).to eq("bad item id")
    end
  end

  describe 'get /api/v1/items/item_id/merchant' do 
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

    it 'bad integer returns 404' do 
      merchant = create(:merchant, id: 1)
      item = create(:item, id: 2)
      get "/api/v1/items/#{4}/merchant"

      expect(response).to have_http_status 404
      errors = JSON.parse(response.body, symbolize_names: true)

      expect(errors[:error]).to eq("bad item id")

    end
  end

end