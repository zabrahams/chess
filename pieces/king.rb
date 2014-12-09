class King < SteppingPiece

  def moves
    moves = super(STRAIGHT + DIAGONAL)
    moves << [2, pos[1]] if board.can_castle?(:left, color)
    moves << [6, pos[1]] if board.can_castle?(:right, color)

    moves
  end

  def render
    color == :black ? "\u265a" : "\u2654"
  end
end
