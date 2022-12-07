class Api::V1::MerchantsController < ApplicationController 
  def index 

    render json: MerchantSerializer.new(Merchant.all) 

    # require 'pry'; binding.pry
  end

  def show 
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render json: {error: "no merchant id"}, status: 404
    end 
  end
end