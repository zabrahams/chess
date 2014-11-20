class InputError < StandardError
end

class Game
  attr_reader :board, :colors, :white, :black

  def initialize(white, black, position = nil)
    @board = Board.new(position)
    @white = white
    @black = black
    @fifty_move_count = 0
    @previous_positions = Hash.new(0)
    @previous_positions[board.extract_positions] += 1
    @colors = { white => :white,
               black => :black }
  end

  def play
    until over?(:white) || over?(:black)
      [white, black].each do |player|
        board.display
        begin
          puts "It is #{colors[player]}'s turn!"
          move = player.play_turn
          make_move(move, colors[player])

        rescue MoveError => err
          puts err.message
          puts "Please select a different move."
          retry
        end

      @previous_positions[board.extract_positions] += 1
      break if over?(other_color(colors[player]))
      end
    end

    board.display
     winner ? (puts "The winner is #{winner}.") : (puts draw_message)
  end

  private

  def make_move(move, color)

    start_pos, end_pos = move
    piece = board[start_pos]
    prev_captures = board.captured[other_color(color)].dup
    player = @colors.key(color)

    if board[end_pos] && piece.color != color
      raise MoveError.new "Trying to move opponent's piece!"
    end

    @fifty_move_count += 1

    board.move(start_pos, end_pos)

    new_captures = board.captured[other_color(color)].dup
    @fifty_move_count = 0 if (piece.is_a?(Pawn) || new_captures != prev_captures)

    if piece.is_a?(Pawn) && piece.prom_line == end_pos[1]
      board.display
      piece = player.promote(piece).new(end_pos, color, board)
      board[end_pos] = piece
    end
  end

  def other_color(color)
    color == :black ? :white : :black
  end

  def over?(color)
    board.checkmate?(:white) || board.checkmate?(:black) || draw(color)
  end

  def winner
    if board.checkmate?(:white)
      :black
    elsif board.checkmate?(:black)
      :white
    else
      nil
    end
  end

  def draw(color)
    stalemate?(color) || fifty_moves? || threefold_repetition? || insufficient_material?
  end

  def draw_message
    if stalemate?(:white) || stalemate?(:black)
      "The game has ended in a draw due to stalemate"
    elsif fifty_moves?
      "The game has ended in a draw due to the fifty rule move."
    elsif threefold_repetition?
      "The game has ended in a draw due to threefold repetition."
    elsif insufficient_material?
       "The game has ended in a draw due to insufficient material."
     end
   end

  def stalemate?(color)
    board.pieces(color).all? { |piece| piece.valid_moves.empty? }
  end

  def fifty_moves?
    @fifty_move_count >= 50
  end

  def threefold_repetition?
    @previous_positions.values.any? { |position_count| position_count >= 3 }
  end

  def insufficient_material?
    return false if bishops_sufficient?

    insufficient = [[:King],
                    [:Bishop, :King],
                    [:King, :Knight]]
    white_pieces = board.pieces(:black).map { |piece| piece.class.name.to_sym }
    white_pieces.sort!
    black_pieces = board.pieces(:black).map { |piece| piece.class.name.to_sym }
    black_pieces.sort!

    (insufficient.include?(white_pieces) &&
    insufficient.include?(black_pieces))
  end

  def bishops_sufficient?
    pieces = board.pieces
    bishops = pieces.select { |piece| piece.is_a?(Bishop) }

    (pieces.count == bishops.count + 2) &&
    (bishops.any? do |bishop|
      bishop.square_color != bishops.first.square_color
    end)

  end

end
