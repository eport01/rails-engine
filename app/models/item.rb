class Item < ApplicationRecord
  belongs_to :merchant 
  attr_readonly :name 
end