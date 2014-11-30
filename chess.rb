# encoding: utf-8

require 'byebug'


require "colorize"
require "./make_checker_board.rb"
require "./pieces.rb"
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
