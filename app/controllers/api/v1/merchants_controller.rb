class Api::V1::MerchantsController < ApplicationController 
  def index 
    render json: MerchantSerializer.new(Merchant.all) 
  end

  def show 
    if Merchant.exists?(params[:id])
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    else
      render json: {error: "no merchant id"}, status: 404
    end 
  end

  def find 
    if params[:name]
      render json: MerchantSerializer.new(Merchant.where(name: params[:name]).order(:name)[0])
    else
      render json: {error: "no merchant name exists"}, status: 404
    end
  end
end