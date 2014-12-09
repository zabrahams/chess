class Knight < SteppingPiece

  def moves
    super(HORSE)
  end

  def render
    color == :black ? "\u265e" : "\u2658"
  end

end
