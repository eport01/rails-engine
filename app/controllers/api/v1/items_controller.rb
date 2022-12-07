class Api::V1::ItemsController < ApplicationController
  def index 
    # if params[:merchant_id]
    #   render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
    # else
      render json: ItemSerializer.new(Item.all) 
    # end
    # require 'pry'; binding.pry
  end

  def show 
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create 
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def update 
    if Item.update(params[:id], item_params).save 
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render json: {error: "unable to update"}, status: 400
    end
  end

  def destroy 
    render json: Item.delete(params[:id])
  end

  private 
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end