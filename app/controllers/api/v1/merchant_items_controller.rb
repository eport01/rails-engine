class Api::V1::MerchantItemsController < ApplicationController
  def index 
    render json: ItemSerializer.new(Merchant.find(params[:id]).items)
  end

  def show 
    render json: MerchantSerializer.new(Item.find(params[:id]).merchant)
  end
end