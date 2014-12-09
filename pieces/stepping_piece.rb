class SteppingPiece < Piece

  def moves(directions)
    moves = []

    directions.each do |dir|
      new_pos = pos_add(pos, dir)
      if Piece.on_board?(new_pos)
        unless !board[new_pos].nil? && board[new_pos].color == self.color
          moves << new_pos
        end
      end
    end

    moves
  end

end
