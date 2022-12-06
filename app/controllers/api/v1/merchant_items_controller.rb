class Api::V1::MerchantItemsController < ApplicationController
  def show 
    
    render json: Item.all(params[:item_id])
  end
end