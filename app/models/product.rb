class Product < ActiveRecord::Base
  default_scope :order => 'title'
  has_many :line_items
  has_many :orders, :through => :line_items

  #consistency
  before_destroy :ensure_not_referenced_by_any_line_item

  # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item 
    if line_items.count.zero?
      return true 
    else
      errors.add(:base, 'Line Items present')
      return false 
    end
  end

  #validation stuff
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}, :presence => true
  validates :title, :uniqueness => true, :presence => true
  validates :description, :presence => true
  validates :image_url, :presence => true, :format => {
    :with     => %r{\.(gif|jpg|png)$}i,
    :message  => 'must be a URL for GIF, JPG, or PNG image.'
  }
end
