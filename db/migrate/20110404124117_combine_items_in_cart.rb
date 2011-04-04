class CombineItemsInCart < ActiveRecord::Migration
  def self.up
    Cart.all.each do |cart|
      #count the number of each product
      sums = cart.line_items.group(:product_id).sum(:quantity)

      sums.each do |product_id, quantity|
        if quantity > 1
          #remove all items
          cart.line_items.where(:product_id=>product_id).delete_all

          #add new row
          cart.line_items.create(:product_id=>product_id, :quantity=>quantity)
        end
      end
    end
  end

  def self.down
    LineItem.where('quantity>1').each do |line_item|
      #add individual items
      line_item.quantity.times do 
        LineItem.create :cart_id => line_item.cart_id, :product_id => line_item.product_id, :quantity => 1
      end
      line_item.destroy
    end 
  end
end
