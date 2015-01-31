class Pawn < Piece

  attr_reader :prom_line, :direction
  attr_accessor :pass_left, :pass_right

  def initialize(pos, color, board)
    @direction = color == :black ? -1 : 1
    @start_y = color == :black ? 6 : 1
    @prom_line = color == :black ? 0 : 7
    @pass_left, @pass_right = false, false
    super
  end

  def render
    color == :black ? "\u265f" : "\u2659"
  end

  def moves
    moves = diagonal_moves + vertical_moves + en_passant_moves
  end

  def diagonal_moves
    moves = [pos_add(pos, [1, @direction]), pos_add(pos, [-1, @direction])]

    moves.select do |move|
      Piece.on_board?(move) &&
      @board[move] &&
      @board[move].color != self.color
    end
  end

  def vertical_moves
    new_pos = pos_add(pos, [0, @direction])

    return [] unless @board[new_pos].nil? && Piece.on_board?(new_pos)

    moves = [new_pos]

    if pos[1] == @start_y
      new_pos = pos_add(pos, [0, 2 * @direction])
      moves << new_pos if @board[new_pos].nil?
    end

    moves
  end

  def en_passant_moves
    [].tap do |moves|
      moves << pos_add(pos, [1, @direction]) if pass_right
      moves << pos_add(pos, [-1, @direction]) if pass_left
    end
  end

  def reset_en_passant
    @pass_left, @pass_right = false, false
  end

  def promotes?
    prom_line == pos[1]
  end
end
