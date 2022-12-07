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
    
    # render json: Item.destroy(params[:id])
    @item = Item.find(params[:id])
    if @item
      render json: Item.destroy(params[:id])
      # @item.destroy_empty_invoices


    #   render json: {item: item, invoices: invoices}
      # render json: Item.destroy(params[:id])
      # render json: Invoice.destroy(params[:id])

      # require 'pry'; binding.pry
      # @item.destroy_empty_invoices
      # render json: @item.destroy_empty_invoices
    else
      render json: {error: "no item id"}, status: 404
    end
  end

  # @item = Item.find(params[:id])
  #if an items invoices only has that item, then destroy
  # if @item.invoices.empty? 
  #   render json: Item.destroy(params[:id])
  # render json: Invoice.destroy(params[:id])
  # end
  

  private 
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end