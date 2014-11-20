class InputError < StandardError
end

class Game
  attr_reader :board, :colors, :white, :black

  def initialize(white, black)
    @board = Board.new
    @white = white
    @black = black
    @fifty_move_count = 0
    @previous_positions = Hash.new(0)
    @previous_positions[board.extract_positions] += 1
    @colors = { white => :white,
               black => :black }
  end

  def play
    until over?
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
      break if over?
      end
    end

    board.display
     winner ? (puts "The winner is #{winner}.") : (puts "Draw game.")
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

  def over?
    board.checkmate?(:white) || board.checkmate?(:black) || draw
  end

  def winner
    if over?
      if board.checkmate?(:white)
        return :black
      elsif board.checkmate?(:black)
        return :white
      end

    nil
    end
  end

  def draw
    stalemate || fifty_moves || threefold_repetition || insufficient_material
  end

  def stalemate
    false
  end

  def fifty_moves
    draw = @fifty_move_count >= 50
    puts "You've reached the fifty move count." if draw
    draw
  end

  def threefold_repetition
    draw =@previous_positions.values.any? { |position_count| position_count >= 3 }
    puts "You've made a threefold reptitions"
    draw
  end

  def insufficient_material
    false
  end

end
