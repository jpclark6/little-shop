class Cart
  attr_reader :contents

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def current_items
    @contents.map { |item_id, qty| Item.find(item_id) }
  end

  def total_count
    @contents.values.sum
  end

  def add_item(id)
    if @contents[id.to_s]
      @contents[id.to_s] = @contents[id.to_s] + 1
    else
      @contents[id.to_s] = 1
    end
  end

  def count_of(id)
   @contents[id.to_s].to_i
  end

  def qty(item)
    @contents[item.id.to_s]
  end

  def total_cost
    @contents.sum { |item_id, qty| Item.find(item_id).price * qty }
  end

  def empty?
    @contents.empty?
  end

  def empty_cart
    @contents = {}
  end
end
