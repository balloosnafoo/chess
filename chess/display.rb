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

  BACKGROUND_COLORS = [:red, :blue]

  attr_reader :display, :board, :cursor, :valid_moves

  def initialize(board, debug = false)
    @debug = debug
    @board = board
    @cursor = [0, 0]
    @valid_moves = [0, 0]
  end

  def render
    system("clear")
    board.grid.each_with_index do |row, i|
      bg_idx = i % 2
      row.each_with_index do |cell, j|
        # we have to use print instead of p here, so that it calls #to_s instead of #inspect
        if [i,j] == cursor
          bg_color = :yellow
        elsif valid_moves.include?([i, j])
          bg_color = :green
        else
          bg_color = BACKGROUND_COLORS[(bg_idx + j) % 2]
        end
        print cell.to_s.colorize(background: bg_color)
      end
      puts
    end
  end

  def get_cursor(input, selected)
    if MOVEMENTS.keys.include?(input)
      movement = MOVEMENTS[input]
      register_movement(movement)
      @valid_moves = board[cursor].moves unless selected
      render
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
