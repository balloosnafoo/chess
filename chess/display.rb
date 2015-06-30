require 'io/console'
require_relative 'board'

class Display
  MOVEMENTS = {
    "w"  => [-1, 0],
    "a"  => [0, -1],
    "s"  => [ 1, 0],
    "d"  => [ 0, 1],
    "\r" => [ 0, 0]
  }

  BACKGROUND_COLORS = [:white, :grey]

  attr_reader :display, :board, :cursor

  def initialize(board, debug = false)
    @debug = debug
    @board = board
    @cursor = [0, 0]
  end

  def render
    system("clear")
    board.grid.each_with_index do |row, i|
      bg_idx = i % 2
      row.each_with_index do |cell, j|
        # we have to use print instead of p here, so that it calls #to_s instead of #inspect
        bg_color = [i,j] == cursor ? :yellow : BACKGROUND_COLORS[(bg_idx + j) % 2]
        print cell.to_s.colorize(background: bg_color)
      end
      puts
    end
  end

  def get_cursor
    loop do
      render
      input = $stdin.getch
      movement = MOVEMENTS[input]
      register_movement(movement)
    end
  end

  def register_movement(movement)
    dx, dy = movement
    position = [cursor[0] + dx, cursor[1] + dy]
    if board.on_board?(position)
      @cursor = position
    end
  end

end



# until chosen
#   input = $stdin.getch
#   movement = MOVEMENTS[input]
#   chosen = true if input == "\r"
# end
# register_mov
