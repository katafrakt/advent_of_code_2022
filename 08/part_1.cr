class Tree
  getter :x, :y, :h
  def initialize(@x : Int32, @y : Int32, @h : Int32)
  end
end

class Candidates
  def initialize
    @max = -1
    @left_visible = [] of Tree
    @right_candidates = [] of Tree
  end

  def add(tree : Tree)
    @left_visible << tree if tree.h > @max
    @right_candidates.select! {|t| t.h > tree.h}
    @right_candidates << tree
    @max = tree.h if tree.h > @max
  end

  def visible
    @left_visible + @right_candidates
  end
end

lines = File.read("input").split("\n")

rows = [] of Candidates
cols = [] of Candidates

lines.each_with_index do |line, y|
  rows << Candidates.new
  line.split("").each_with_index do |char, x|
    cols << Candidates.new if cols.size <= x
    tree = Tree.new(x, y, char.to_i)
    rows[y].add(tree)
    cols[x].add(tree)
  end
end

visibles = (rows + cols).map {|r| r.visible}.flatten.uniq
puts visibles.size