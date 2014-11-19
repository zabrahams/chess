class InputError < StandardError
end

class Game
  attr_reader :board, :colors, :white, :black

  def initialize(white, black)
    @board = Board.new
    @white = white
    @black = black
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

      break if over?
      end
    end

    board.display
    puts "The winner is #{winner}."
  end

  private

  def make_move(move, color)
    start_pos, end_pos = move
    piece = board[start_pos]
    player = @colors.key(color)

    if board[end_pos] && piece.color != color
      raise MoveError.new "Trying to move opponent's piece!"
    end

    board.move(start_pos, end_pos)

    if piece.is_a?(Pawn) && piece.prom_line == end_pos[1]
      board.display
      piece = player.promote(piece).new(end_pos, color, board)
      board[end_pos] = piece
    end
  end

  def over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

  def winner
    if over?
      return (board.checkmate?(:white) ? :white : :black)
    end

    nil
  end

end
