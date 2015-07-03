require 'io/console'

class Player

  def initialize(name, game)
    @name = name
    @game = game
  end

end

class HumanPlayer < Player

  def choose_square
    chosen = false
    movement = nil
    until chosen
      puts "feel free to move your cursor (WASD) and then press enter"
      input = $stdin.getch
      @game.update_cursor(input)
      chosen = true if input == "\r"
      exit if input == "p"
    end
  end

end
# class ComputerPlayer < Player
#
# end
