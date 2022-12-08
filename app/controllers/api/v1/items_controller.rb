class Api::V1::ItemsController < ApplicationController
  def index 
    render json: ItemSerializer.new(Item.all) 
  end

  def show 
    if Item.exists?(params[:id])
      #  require 'pry'; binding.pry
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {error: "no item id"}, status: 404
    end
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
    if params[:min_price] && params[:name] || params[:max_price] && params[:name]

      render json: {error: "Can't send both name and price"}, status: 400 

    elsif params[:name]
      items = Item.where("name ILIKE ?", "%#{params[:name]}%")
      if items != nil 
        render json: ItemSerializer.new(items)
      else
        render json: {data: [error: items]}, status: 200 
      end
    elsif params[:min_price] && params[:max_price]

    elsif params[:min_price]
      
      if params[:min_price].to_i > 0 
        items = Item.where("unit_price > ?", "#{params[:min_price]}")
        render json: ItemSerializer.new(items)
      else
        render json: {errors: "Min price has to be above 0"}, status: 400 
      end
    elsif params[:max_price]
      if params[:max_price].to_i > 0
        items = Item.where("unit_price < ?", "#{params[:max_price]}")
        render json: ItemSerializer.new(items)
      else
        render json: {errors: "Max price has to be above 0"}, status: 400 
      end
    else 
      render json: {error: "can't send empty params"}, status: 400 

    end

  end

  def min_price

  end

  def max_price

  end




  private 
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end