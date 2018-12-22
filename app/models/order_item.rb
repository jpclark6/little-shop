class OrderItem < ApplicationRecord
  # validates_presence_of :price, :quantity
  # These would ideally be here (along with tests). Breaks Rspec for now
  # Would need to be accompanied by perhaps a before_validation method on the model

  belongs_to :item
  belongs_to :order

  def subtotal
    quantity * price
  end
end
