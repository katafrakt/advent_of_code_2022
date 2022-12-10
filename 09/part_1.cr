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

head = Coord.new(0, 0)
tail = Coord.new(0, 0)
tail_history = [] of Tuple(Int32, Int32)

def move_tail_to_head(tail, head)
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
    head.move(dir)
    move_tail_to_head(tail, head)
    tail_history << tail.to_tuple
  end
end

puts tail_history.uniq.size