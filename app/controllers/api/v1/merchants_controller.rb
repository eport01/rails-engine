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
    merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)[0]
    if merchant != nil 
      # merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)[0]
      render json: MerchantSerializer.new(merchant)
      # render json: MerchantSerializer.new(Merchant.where("name ILIKE ?", "%#{params[:name]}%"))

    else
      render json: {error: "no merchant name exists"}, status: 404
    end
  end
end