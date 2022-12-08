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
    merchant = Merchant.find_by_name(params[:name])
    # merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%").order(:name)[0]
    if merchant != nil 
      render json: MerchantSerializer.new(merchant)
    else
      render json: {data: {error: merchant}}, status: 200 
    end
  end
end