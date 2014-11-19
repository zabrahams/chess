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
        system "clear"
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

    system "clear"
    board.display
    puts "The winner is #{winner}."
  end

  private

  def make_move(move, color)
    start_pos, end_pos = move

    if board[end_pos] && board[start_pos].color != color
      raise MoveError.new "Trying to move opponent's piece!"
    end

    board.move(start_pos, end_pos)
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
