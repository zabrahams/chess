class InputError < StandardError
end

class Game
  attr_reader :board, :colors, :white, :black
  attr_accessor :current_player

  def initialize(white, black)
    @board = Board.new
    @white = white
    @black = black
    @colors = { white => :white,
               black => :black }
    @current_player = white
  end

  def play
    until over?
      system "clear"
      board.display
      begin
        puts "It is #{colors[current_player]}'s turn!"
        move = current_player.play_turn
        make_move(move)
      rescue MoveError => err
        puts err.message
        puts "Please select a different move."
        retry
      end

      next_player
    end

    system "clear"
    board.display
    puts "The winner is #{winner}."
  end

  def make_move(move)
    color = colors[current_player]
    start_pos, end_pos = move

    if board[start_pos].color != color
      raise MoveError.new "Trying to move opponent's piece!"
    end

    board.move(start_pos, end_pos)
  end

  private

  def next_player
    self.current_player = current_player == white ? black : white
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
