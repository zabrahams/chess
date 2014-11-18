class Piece


end

class SlidingPiece < Piece
end

class SteppingPiece < Piece
end

class Pawn < Piece
end

class Queen < SlidingPiece
end

class Rook < SlidingPiece
end

class Bishop < SlidingPiece
end

class Knight < SteppingPiece
end

class King < SteppingPiece
end
