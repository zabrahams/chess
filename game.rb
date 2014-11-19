require "./board.rb"

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
               black => :black
              }
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
      board.checkmate?(:white) ? (return :white) : (return :black)
    end

    nil
  end

end

class HumanPlayer

  def play_turn
    start_pos = get_input("Enter the coordinates of the piece you want to move:")
    end_pos = get_input ("Enter the coordinates of the square you want to move it to:")

    [start_pos, end_pos]
  end

  private

  def get_input(prompt)
    puts prompt

    begin
      print ">"
      pos = gets.chomp
      pos = parse_input(pos)
    rescue InputError => err
      puts err.message
      retry
    end

    pos
  end

  def parse_input(input)
    validate_input(input)

    input.split(",").map(&:to_i)
  end

  def validate_input(input)
    good_input = /\A[0-7],[0-7]\z/
    unless input =~ good_input
      raise InputError.new "Please enter valid coordinates. For example: 2,3"
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new
  p2 = HumanPlayer.new
  g = Game.new(p1, p2)
  g.play
end
