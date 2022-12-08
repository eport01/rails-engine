class Api::V1::ItemsController < ApplicationController
  def index 
    render json: ItemSerializer.new(Item.all) 
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
    @item = Item.find(params[:id])
    if @item
      render json: Item.destroy(params[:id])
    else
      render json: {error: "no item id"}, status: 404
    end
  end  

  def find_all 
    items = Item.where("name ILIKE ?", "%#{params[:name]}%")
    if items != nil 
      render json: ItemSerializer.new(items)
    else
      render json: {data: [error: items]}, status: 200 
    end
  end

  private 
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end