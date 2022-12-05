require 'rails_helper' 

describe "Items API endpoints" do 
  it "sends a list of all items " do 
    create_list(:items, 3)

    get '/api/v1/items'

    expect(response).to be_successful
  end
end