require "./pieces.rb"

class MoveError < StandardError
end

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

  def initialize(positions = nil)
    positions ||= (START_POS.merge(Board.generate_pawns))
    @grid = Array.new(8) { Array.new(8) }
    place_pieces(positions)
  end

  def dup
    positions = extract_position
    Board.new(positions)
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

  def move(start, end_pos)

    begin
      piece = self[start]
      raise MoveError.new "No piece at this location." if piece.nil?
      raise MoveError.new "Target position blocked." unless piece.moves.include?(end_pos)
    rescue MoveError => err
      puts err.message
    end

    self[start] = nil
    self[end_pos] = piece
    piece.pos = end_pos
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
    render
  end

  def render

    @grid.reverse.map do |row|
      row.map do |square|
        square.nil? ? "_" : "#{square.render}"
      end.join(" ")
    end.join("\n")

  end

  def display
    puts render
  end

  private

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

  def place_pieces(positions = start)

    positions.each do |pos, piece|
      self[pos] = (piece[0].new(pos, piece[1], self))
    end
  end

  def find_king(color)
    pieces(color).select { |piece| piece.class == King }.first
  end

  def extract_position
    positions = {}
    pieces.each do |piece|
      positions[piece.pos.dup] = [piece.class, piece.color]
    end

    positions
  end

end
