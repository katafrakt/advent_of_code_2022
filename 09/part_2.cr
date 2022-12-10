class Coord
  getter :x, :y
  def initialize(@x : Int32, @y : Int32)
  end

  def move(dir)
    case dir
    when "U" then @y -= 1
    when "D" then @y += 1
    when "R" then @x += 1
    when "L" then @x -= 1
    end
  end

  def to_tuple
    {@x, @y}
  end
end

knots = 10.times.map do
  Coord.new(0, 0)
end.to_a
tail_history = [] of Tuple(Int32, Int32)

def follow_previous(tail, head)
  dx = head.x - tail.x
  dy = head.y - tail.y

  if dx.abs <= 1 && dy.abs <= 1
    # no-op
  elsif dx == 0
    dy < 0 ? tail.move("U") : tail.move("D")
  elsif dy == 0
    dx < 0 ? tail.move("L") : tail.move("R")
  else
    dy < 0 ? tail.move("U") : tail.move("D")
    dx < 0 ? tail.move("L") : tail.move("R")
  end
end

lines = File.read("input").split("\n")
lines.each do |line|
  dir, num = line.split(" ")
  num.to_i.times do
    knots[0].move(dir)
    (1..9).each do |x|
      current = knots[x]
      previous = knots[x - 1]
      follow_previous(current, previous)
    end
    tail_history << knots[9].to_tuple
  end
end

p knots[0].to_tuple
p knots[9].to_tuple
puts tail_history.uniq.size