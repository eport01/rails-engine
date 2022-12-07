class Api::V1::MerchantsController < ApplicationController 
  def index 

    render json: MerchantSerializer.new(Merchant.all) 

    # require 'pry'; binding.pry
  end

  def show 


    #for merchant items: 
    
      # render json: ItemSerializer.new(Merchant.find(params[:id]).items)
      # require 'pry'; binding.pry

    #to get one merchant  
    render json: MerchantSerializer.new(Merchant.find(params[:id]))

    
  end
end