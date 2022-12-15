class Api::V1::ItemsController < ApplicationController
  def index 
    render json: ItemSerializer.new(Item.all) 
  end

  def show 
    if Item.exists?(params[:id])
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {error: "bad item id"}, status: 404
    end
  end

  def create 
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def update 
    if Item.exists?(params[:id]) && Item.update(params[:id], item_params).save 
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render json: {error: "unable to update"}, status: 404
    end
  end

  def destroy 
    if Item.exists?(params[:id])
      render json: Item.destroy(params[:id])
    else
      render json: {error: "bad item id"}, status: 404
    end
  end  

  def find_all 
    params_variables

    if @min_price && @name || @max_price && @name || @max_price && @min_price
      render json: {error: "Error!"}, status: 400 
    elsif @name && @name != ""
      self.items_by_name(@name)
    elsif @min_price
      self.items_above_price(@min_price)
    elsif @max_price
      self.items_below_price(@max_price)
    else 
      render json: {error: "Error!"}, status: 400 
    end
  end

  private 
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def params_variables 
    @name = params[:name]
    @min_price = params[:min_price]
    @max_price = params[:max_price]
  end


  def items_above_price(params_variable)
    min_price = params[:min_price]
    if min_price.to_i > 0 
      items= Item.above(min_price)
      render json: ItemSerializer.new(items)
    else
      render json: {errors: "Error!"}, status: 400 
    end
  end

  def items_below_price(params_variable)
    max_price = params[:max_price]
    if max_price.to_i > 0
      items = Item.below(max_price)
      render json: ItemSerializer.new(items)
    else
      render json: {errors: "Error!"}, status: 400 
    end
  end

  def items_by_name(params_variable)
    name = params[:name]
    items = Item.find_by_name(name)
    if items != nil || items != []
      render json: ItemSerializer.new(items)
    end
  end
end