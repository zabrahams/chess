class BoardRenderer

  def initialize(captured, grid)
    @captured = captured
    @grid = grid
  end

  def render
    switch = true
    row_number = 9

    captured_piece_border(:black) << hori_border <<
    @grid.reverse.map do |row|
      switch = !switch
      row_number -= 1
      " #{row_number} ".on_light_white <<
      row.map do |square|
        (switch = !switch)
        square.nil? ? "   ".checker(switch) : " #{square.render} ".checker(switch)
      end.join("") <<  " #{row_number} \n".on_light_white
    end.join("".on_light_white) <<
    hori_border << captured_piece_border(:white)
  end

  private

  def captured_piece_border(color)
    captured = "#{@captured[color].map(&:render).join unless @captured[color].empty?}"
    target_length = 30
    white_space = (target_length - @captured[color].length)
    "#{captured}#{" " * white_space}\n".on_light_white
  end

  def top_border
    "#{" " * 30}\n".on_light_white
  end

  def hori_border
    ("   " << ("A".."Z").to_a[0...Board::BOARD_SIZE].map do |letter|
      " #{letter} "
    end.join("") << "   \n").on_light_white
  end


end
