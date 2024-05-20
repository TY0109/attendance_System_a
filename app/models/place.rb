class Place < ApplicationRecord
  
  validates :number, presence:true
  validates :name, presence:true
  validates :working_style, presence:true
  
  
end
