class Piece

  STRAIGHT = [[1, 0], [0, 1], [-1, 0], [0, -1]]
  DIAGONAL = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  HORSE =    [[-2, 1], [-1, 2], [2, 1], [-2, -1],
              [1, -2], [-1, -2], [2, -1], [1, 2]]



  attr_reader :pos, :color, :board

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def pos_add(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end

end

class SlidingPiece < Piece


  def moves(directions)
    moves = []

    directions.each do |dir|
      current_pos = pos_add(pos, dir)
      while current_pos.all { |num| num.between?(0, 7) }
        moves << current_pos
        current_pos = pos_add(current_pos, dir)
      end
    end

    moves
  end
end

class SteppingPiece < Piece

  def moves(directions)
    moves = []

    directions.each do |dir|
      new_pos = pos_add(pos, dir)
      moves << new_pos if new_pos.all? { |num| num.between?(0, 7) }
    end

    moves
  end
end

class Pawn < Piece

  def initialize(pos, color, board)
    @start_pos = pos.dup
    super
  end

  def moves

    y_moves = {:black => -1, :white => 1}

    directions = [[-1, y_moves[color]],
                  [0, y_moves[color]],
                  [1, y_moves[color]]]

    current_pos = pos

    moves = []

    directions.each do |dir|
      new_pos = pos_add(pos, dir)
      moves << new_pos if new_pos.all? { |num| num.between?(0, 7) }
    end

    if pos == @start_pos
      moves << pos_add(pos, [0, 2 * y_moves[color]])
    end

    moves
  end

end

class Queen < SlidingPiece

  def moves
    super(STRAIGHT + DIAGONAL)
  end

end

class Rook < SlidingPiece

  def moves
    super(STRAIGHT)
  end
end

class Bishop < SlidingPiece

  def moves
    super(DIAGONAL)
  end
end

class Knight < SteppingPiece

  def moves
    super(HORSE)
  end

end

class King < SteppingPiece

  def moves
    super(STRAIGHT + DIAGONAL)
  end

end
