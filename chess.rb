# encoding: utf-8

require 'byebug'


require "colorize"
require "./make_checker_board.rb"

require "./pieces/piece.rb"
require "./pieces/sliding_piece.rb"
require "./pieces/stepping_piece.rb"
require "./pieces/pawn.rb"
require "./pieces/king.rb"
require "./pieces/queen.rb"
require "./pieces/rook.rb"
require "./pieces/bishop.rb"
require "./pieces/knight.rb"

require "./board.rb"
require "./human_player.rb"
require "./computer_player.rb"
require "./game.rb"
require "./debug_pos.rb"


if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new
  p2 = HumanPlayer.new
  g = Game.new(p1, p2)
  g.play
end
