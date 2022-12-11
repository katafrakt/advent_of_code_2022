require "big"
class Item
  @@modulos = [2, 7, 11, 19, 3, 5, 17, 13]
  @modulos : Hash(Int32, Int32)
  getter :value

  def initialize(value : Int32)
    @modulos = @@modulos.map do |mod|
      [mod, value % mod]
    end.to_h
  end

  def process(op : Proc(Int32, Int32))
    @modulos = @modulos.map do |key, val|
      val = op.call(val) % key
      [key, val]
    end.to_h
  end

  def div_by?(num)
    @modulos[num] == 0
  end
end

class Monkey
  @items : Array(Item)
  getter :inspects
  def initialize(@pos : Int32, items : Array(Int32), @operation : Proc(Int32, Int32), @test : Int32, @ontrue : Int32, @onfalse : Int32)
    @items = items.map {|i| Item.new(i)}
    @inspects = 0
  end

  def catch_item(item : Item)
    @items << item
  end

  def inspect_items
    @items.map do |item|
      @inspects += 1
      item.process(@operation)
      target = item.div_by?(@test) ? @ontrue : @onfalse
      {target, item}
    end.tap do
      @items = [] of Item
    end
  end
end

prod_monkeys = [
  Monkey.new(0, [66, 59, 64, 51], ->(num : Int32) { num * 3}, 2, 1, 4),
  Monkey.new(1, [67, 61], ->(num : Int32) { num * 19}, 7, 3, 5),
  Monkey.new(2, [86, 93, 80, 70, 71, 81, 56], ->(num : Int32) { num + 2}, 11, 4, 0),
  Monkey.new(3, [94], ->(num : Int32) { num * num }, 19, 7, 6),
  Monkey.new(4, [71, 92, 64], ->(num : Int32) { num + 8}, 3, 5, 1),
  Monkey.new(5, [58, 81, 92, 75, 56], ->(num : Int32) { num + 6}, 5, 3, 6),
  Monkey.new(6, [82, 98, 77, 94, 86, 81], ->(num : Int32) { num + 7 }, 17, 7, 2),
  Monkey.new(7, [54, 95, 70, 93, 88, 93, 63, 50], ->(num : Int32) { num + 4}, 13, 2, 0)
]

def do_round(monkeys : Array(Monkey))
  monkeys.each do |monkey|
    monkey.inspect_items.each do |result|
      target_monkey = monkeys[result[0]]
      target_monkey.catch_item(result[1])
    end
  end
end

10_000.times do |i|
  #puts i + 1 if (i + 1) % 100 == 0 
  do_round(prod_monkeys)
end
p prod_monkeys.map {|m| m.inspects}.sort.reverse[0..1].reduce(1.to_i128) {|acc, i| acc * i.to_i128}