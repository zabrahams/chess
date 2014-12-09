class Bishop < SlidingPiece

  def moves
    super(DIAGONAL)
  end

  def render
    color == :black ? "\u265d" : "\u2657"
  end

end
