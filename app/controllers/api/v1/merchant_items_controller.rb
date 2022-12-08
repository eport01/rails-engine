class Api::V1::MerchantItemsController < ApplicationController
  def index 
    if Merchant.exists?(params[:id])
      render json: ItemSerializer.new(Merchant.find(params[:id]).items)
    else
      render json: {errors: "no merchant id"}, status: 404

    end
  end

  def show 
    if Item.exists?(params[:id])
      render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
    else
      render json: {error: "bad item id"}, status: 404
    end
  end
end