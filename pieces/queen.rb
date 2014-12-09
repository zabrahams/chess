class Queen < SlidingPiece

  def moves
    super(STRAIGHT + DIAGONAL)
  end

  def render
    color == :black ? "\u265b" : "\u2655"
  end

end
