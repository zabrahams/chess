require "./pieces.rb"

class Board

  START_POS = {
    [0, 0] => [Rook, :white],
    [1, 0] => [Knight, :white],
    [2, 0] => [Bishop, :white],
    [3, 0] => [Queen, :white],
    [4, 0] => [King, :white],
    [5, 0] => [Bishop, :white],
    [6, 0] => [Knight, :white],
    [7, 0] => [Rook, :white],
    [0, 7] => [Rook, :black],
    [1, 7] => [Knight, :black],
    [2, 7] => [Bishop, :black],
    [3, 7] => [King, :black],
    [4, 7] => [Queen, :black],
    [5, 7] => [Bishop, :black],
    [6, 7] => [Knight, :black],
    [7, 7] => [Rook, :black]
  }

  def self.generate_pawns

    pawns = Hash.new {[]}
    (0..7).each do |x|
      pawns[[x, 1]] = [Pawn, :white]
      pawns[[x, 6]] = [Pawn, :black]
    end

    pawns
  end

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    place_pieces
  end

  def in_check?(color)
    king = find_king(color)
    color == :white ? enemy = :black : enemy = :white

    pieces(enemy).any? do |piece|
      piece.moves.any? do |move|
        move == king.pos
      end
    end
  end

  def [](pos)
    x, y = pos
    @grid[y][x]
  end


  def []=(pos, value)
    x, y = pos
    @grid[y][x] = value
  end

  def inspect
    pieces.map do |piece|
      { piece.pos => [piece.color, piece.class] }
    end.to_s
  end

  def squares
    @grid.flatten
  end

  def pieces(color = nil)
    all_pieces = squares.reject(&:nil?)

    if color.nil?
      all_pieces
    else
      all_pieces.select { |piece| piece.color == color}
    end
  end

  private

  def place_pieces
    (START_POS.merge(Board.generate_pawns)).each do |pos, piece|
      self[pos] = (piece[0].new(pos, piece[1], self))
    end
  end

  def find_king(color)
    pieces(color).select { |piece| piece.class == King }.first
  end

end
