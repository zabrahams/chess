class SlidingPiece < Piece

  def moves(directions)
    moves = []

    directions.each do |dir|
      current_pos = pos_add(pos, dir)
      while Piece.on_board?(current_pos)
        unless board[current_pos].nil?
          moves << current_pos unless board[current_pos].color == self.color
          break
        end

        moves << current_pos
        current_pos = pos_add(current_pos, dir)
      end
    end

    moves
  end

end
