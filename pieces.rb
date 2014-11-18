class Piece
  attr_reader :pos, :color, :board

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

end

class SlidingPiece < Piece

STRAIGHT = [[1, 0], [0, 1], [-1, 0], [0, -1]]

DIAGONAL = [[1, 1], [-1, 1], [1, -1], [-1, -1]]


  def moves(directions)
    moves = []


    directions.each do |dir|
      current_pos = pos_add(pos, dir)
      while current_pos.all?{|num| num.between?(0, 7)}
        moves << current_pos
        current_pos = pos_add(current_pos, dir)
      end
    end

    moves

  end

  def pos_add(pos1, pos2)
    [pos1[0] + pos2[0], pos1[1] + pos2[1]]
  end

end

class SteppingPiece < Piece
end

class Pawn < Piece
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
end

class King < SteppingPiece
end
