class Rook < SlidingPiece

  def moves
    moves = super(STRAIGHT)
    direction = (pos[1] == 0 ? :left : :right)
    if board.can_castle?(direction, color)
      moves << (direction == :left ? [3, pos[1]] : [5, pos[1]])
    end

    moves
  end

  def render
    color == :black ? "\u265c" : "\u2656"
  end

end
