class Api::V1::MerchantsController < ApplicationController 
  def index 

    render json: MerchantSerializer.new(Merchant.all) 

    # require 'pry'; binding.pry
  end

  def show 
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
    
  end
end