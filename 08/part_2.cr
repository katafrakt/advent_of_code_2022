class Tree
  getter :x, :y, :h
  def initialize(@x : Int32, @y : Int32, @h : Int32)
  end
end

alias Coord = Tuple(Int32, Int32)
trees = Hash(Coord, Int32).new

File.read("input").split("\n").each_with_index do |line, y|
  line.split("").each_with_index do |char, x|
    trees[{x, y}] = char.to_i
  end
end

def calc_score_dir(trees, h, pos, dir, score)
  new_pos = {pos[0] + dir[0], pos[1] + dir[1]}
  if !trees.has_key?(new_pos)
    score - 1
  elsif trees[new_pos] >= h
    score
  else 
    calc_score_dir(trees, h, new_pos, dir, score + 1)
  end
end

def calc_score(trees, x, y)
  h = trees[{x, y}]
  calc_score_dir(trees, h, {x, y}, {-1, 0}, 1) * 
    calc_score_dir(trees, h, {x, y}, {1, 0}, 1) *
    calc_score_dir(trees, h, {x, y}, {0, 1}, 1) * 
    calc_score_dir(trees, h, {x, y}, {0, -1}, 1)
end

s = Math.sqrt(trees.size).to_i
max_score = 0
(0...s).each do |y|
  (0...s).each do |x|
    score = calc_score(trees, x, y)
    max_score = score if score > max_score
  end
end

puts max_score