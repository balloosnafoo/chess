require 'byebug'
require_relative "board.rb"
require_relative "display.rb"
require_relative "player.rb"

class Chess
  attr_reader :board, :current_player, :display, :selected

  def initialize
    @board = Board.new
    @playerA = HumanPlayer.new("one", self)
    @playerB = HumanPlayer.new("two", self)
    @display = Display.new(board)
    @turn = {
      @playerA => @playerB,
      @playerB => @playerA
    }
    @current_player = @playerA
    @selected = false
  end

  def render
    @display.render
  end

  def play
    loop do
      display.render
      # debugger
      current_player.choose_square
      piece = display.cursor.dup
      current_player.choose_square
      target = display.cursor.dup
      board.move_piece(piece, target)
      @current_player = @turn[@current_player]
    end
  end

  def update_cursor(input)
    display.get_cursor(input, selected)
    @selected = !selected if input == "\r"
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Chess.new
  game.play
end
