class Player

  PIECES = { "Q" => Queen, "R" => Rook, "B" => Bishop, "Kn" => Knight }

  def play_turn
    start_pos = get_input("Enter the coordinates of the piece you want to move:")
    end_pos = get_input ("Enter the coordinates of the square you want to move it to:")

    [start_pos, end_pos]
  end

  def promote(piece)
    begin
      puts "You have reached the opponents back rank! Please select the piece you want to promote your pawn to."
      puts "(Q,R,B,Kn)"
      print ">"
      input = gets.chomp
      raise InputError.new "Not a valid piece." unless PIECES.keys.include?(input)
    rescue InputError => err
      puts err.message
      retry
    end

    PIECES[input]
  end

  private

  def get_input(prompt)
    puts prompt

    begin
      print "(q to quit)>"
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

    x = input[0].ord - "a".ord
    y = input[1].to_i - 1
    [x, y]
  end

  def validate_input(input)
    good_input = /\A[a-h][1-8]\z/
    quit_input = /\A\q\z/
    exit if input =~ quit_input

    unless input =~ good_input
      raise InputError.new "Please enter valid coordinates. For example: d4"
    end
  end

end
