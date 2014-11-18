class Board

  START_POS = {
    [0, 0] = [Rook, :white],
    [0, 1] = [Knight, :white],
    [0, 2] = [Bishop, :white]
  }

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_pieces
  end

  def place_pieces

    START_POS.each do |pos, piece|
        self[pos] = piece[0].new(pos, piece[1], self)
      end
    end

  end

  def []=(pos)
    x, y = pos
    self.grid[y][x]
  end

end
