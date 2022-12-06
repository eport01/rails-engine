class Api::V1::ItemsController < ApplicationController
  def index 
    render json: ItemSerializer.new(Item.all) 
    # require 'pry'; binding.pry
  end
end