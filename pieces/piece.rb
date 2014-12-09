class Piece

  STRAIGHT = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  HORSE =    [[-2, 1], [-1, 2], [2, 1], [-2, -1],
              [1, -2], [-1, -2], [2, -1], [1, 2]]

  attr_accessor :pos, :color, :board

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
    @has_moved = false
  end

  def pos_add(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end

  def self.pos_add(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end

  def self.on_board?(pos)
    pos.all? { |num| num.between?(0, 7) }
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def move_into_check?(square)
    new_board = board.dup
    new_board.move!(pos, square)
    new_board.in_check?(color)
  end

  def has_moved=(value)
    @has_moved = value
  end

  def has_moved?
    @has_moved
  end

  def square_color
    (pos.inject(:+) % 2 == 0)? :dark : :light
  end

end
