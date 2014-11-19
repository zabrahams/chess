require "./board.rb"

class InputError < StandardError
end

class Game

  def initialize(player1, player2)
    @board = Board.new
    @white = player1
    @black = player2
  end


end

class HumanPlayer

  def initialize(color)
    @color = color
  end

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
