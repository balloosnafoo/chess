require 'colorize'
require_relative "empty_square"
require_relative "display"
require_relative "piece"

class Board
  attr_reader :grid, :display

  def initialize
    @grid = Array.new(8){ Array.new(8){ EmptySquare.new }}
    @display = Display.new(self)
    board_setup
  end

  def board_setup
    home_row1 = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    home_row2 = home_row1.reverse
    home_row1.each_with_index do |piece, col|
      self[[0, col]] = piece.new(:white, [0, col], self)
      self[[1, col]] =  Pawn.new(:white, [1, col], self)
      self[[6, col]] =  Pawn.new(:black, [6, col], self)
      self[[7, col]] = piece.new(:black, [7, col], self)
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

  def render
    @display.render
  end

  def on_board?(pos)
    (0..7).include?(pos[0]) && (0..7).include?(pos[1])
  end

  def occupied?(pos)
    self[pos].empty?
  end

  def piece_at(pos)
    self[pos]
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.display.get_cursor
end
