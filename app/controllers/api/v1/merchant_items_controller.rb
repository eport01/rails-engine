class Api::V1::MerchantItemsController < ApplicationController
  def index 
    if Merchant.exists?(params[:id])
      render json: ItemSerializer.new(Merchant.find(params[:id]).items)
    else
      render json: {error: "no merchant id"}, status: 404

    end
  end

  def show 
    render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
  end
end