class Board

  BOARD_SIZE = 8

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
    [3, 7] => [Queen, :black],
    [4, 7] => [King, :black],
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

  attr_reader :captured, :board_renderer

  def initialize(positions = nil)
    positions ||= (START_POS.merge(Board.generate_pawns))
    @grid = Array.new(8) { Array.new(8) }
    place_pieces(positions)
    @captured = { :black => [], :white => [] }
    @board_renderer = BoardRenderer.new(@captured, @grid)
  end

  def dup
    positions = extract_positions
    new_board = Board.new(positions)
    new_board = set_pieces(Rook, new_board)
    set_pieces(King, new_board)
  end

  def set_pieces(wanted_piece, new_board)
    wanted_pieces = pieces.select{ |piece| piece.is_a?(wanted_piece)}

    wanted_pieces.each do |piece|
      pos = piece.pos
      new_board[pos].has_moved = piece.has_moved?
    end
    new_board
  end

  def checkmate?(color)
    in_check?(color) &&
    pieces(color).all? { |piece| piece.valid_moves.empty?}
  end

  def in_check?(color)
    king = find_king(color)
    color == :white ? enemy = :black : enemy = :white

    # Calling in check on a king or an unmoved rook creates an infinite
    # loop. Luckily, a kind or unmoved rook cannot place a castling king
    # in check, so they can just be thrown out of the pieces array.
    pieces = pieces(enemy).reject do |piece|
      piece.is_a?(King) ||
      (piece.is_a?(Rook)  && !piece.has_moved?)
    end

    pieces.any? do |piece|
      piece.moves.any? do |move|
        move == king.pos
      end
    end
  end

  def move(start, end_pos)
    piece = self[start]

    # Testing for invalid moves
    raise MoveError.new "No piece at this location." if piece.nil?
    raise MoveError.new "Invalid move." unless piece.moves.include?(end_pos)
    raise MoveError.new "Move places you in check." unless piece.valid_moves.include?(end_pos)

    # Perform related bookeeping
    capture(end_pos) if self[end_pos]
    set_en_passant(piece) if en_passant?(piece, end_pos)
    piece.has_moved? || piece.has_moved = true

    # Move piece
    move!(start, end_pos)
  end

  def en_passant?(piece, end_pos)
    piece.is_a?(Pawn) &&
    !piece.has_moved? &&
    (end_pos[1] - piece.pos[1].abs == 2)
  end

  def move!(start, end_pos)
    piece = self[start]

    if piece.is_a?(Pawn) &&
      piece.en_passant_moves.include?(end_pos)
      passed_piece_dir = (piece.pass_left ? -1 : 1)
      passed_pawn_pos = Piece.pos_add(start, [passed_pawn_dir, 0])
      self[passed_pawn_pos] = nil
    end

    self[start] = nil
    self[end_pos] = piece
    piece.pos = end_pos

    if castled?(piece, start[0], end_pos[0])
      direction = (end_pos[0] == 2 ? :left : :right)
      castle(direction, piece.color)
    end
  end

  def [](pos)
    x, y = pos
    @grid[y][x]
  end

  def []=(pos, value)
    # This allows [] to set board[-1,0] to [7,0], since -1 is a valid index.
    x, y = pos
    @grid[y][x] = value
  end

  def inspect
    @board_renderer.render
  end

  def display
    system "clear"
    puts @board_renderer.render
  end

  def extract_positions
    positions = {}
    pieces.each do |piece|
      positions[piece.pos.dup] = [piece.class, piece.color]
    end

    positions
  end

  def can_castle?(direction, color)
    x = (direction == :left ? 0 : 7)
    y = (color == :white ? 0 : 7)

    rook = self[[x, y]] || (return false)

    king = find_king(color) || (return false)

    (!rook.has_moved? &&
    !king.has_moved? &&
    empty_between?(rook, king) &&
    can_move_without_check?(king, direction))
  end

  def castle(direction, color)
    rook_x = (direction == :left ? 0 : 7)
    x = (direction == :left ? 3 : 5)
    y = (color == :white ? 0 : 7)

    rook = self[[rook_x, y]]
    self[[x, y]] = rook
    self[[rook_x, y]] = nil
    rook.pos = [x, y]
    rook.has_moved = true
  end

  def castled?(piece, start_x, end_x)
    piece.is_a?(King) && start_x == 4 && (end_x - start_x.abs == 2)
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

  def squares
    @grid.flatten
  end

  def place_pieces(positions = start)
    positions.each do |pos, piece|
      self[pos] = (piece[0].new(pos, piece[1], self))
    end
  end

  def capture(pos)
    color = self[pos].color
    @captured[color] << self[pos]
  end

  def set_en_passant(piece)
    x, y = piece.pos

    left_loc = [x - 1, y + (2 * piece.direction)]
    right_loc = [x + 1, y + (2 * piece.direction)]

    if Piece.on_board?(left_loc)
      left_piece = self[left_loc]
    end

    if Piece.on_board?(right_loc)
      right_piece = self[right_loc]
    end

    if left_piece && left_piece.is_a?(Pawn)
      left_piece.pass_right = true
    end

    if right_piece && right_piece.is_a?(Pawn)
      right_piece.pass_left = true
    end
  end

  def find_king(color)
    pieces(color).select { |piece| piece.is_a?(King) }.first
  end

  def empty_between?(rook, king)
    squares = []

    if king.pos[0] < rook.pos[0]
      i, j = (king.pos[0] + 1), rook.pos[0]
    else
      i, j = (rook.pos[0] + 1), king.pos[0]
    end

    x = (i...j)
    y = king.pos[1]

    x.each do |i|
      squares << [i, y]
    end

    squares.all? { |square| self[square].nil? }
  end

  def can_move_without_check?(king, direction)
    change = (direction == :left ? -1 : 1)
    [0, change, change * 2].none? do |x|
      king.move_into_check?([king.pos[0] + x, king.pos[1]])
    end
  end

end
