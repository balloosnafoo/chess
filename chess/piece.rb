require 'colorize'

class Piece
  attr_reader :pos

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @moved = false
  end

end

class SlidingPiece < Piece

  HORIZONTAL_MOVES = [[1,0],[-1,0],[0,1],[0,-1]]

  def moves
    moves_arr = []
    # could use self.move_dirs here too
    (0..7).each do |i|
      (0..7).each do |j|
        if move_dirs.include?(:straight)
          moves_arr << [i, j] if !obstructed?(pos, [i,j]) && check_straight(i, j)
        end
        if move_dirs.include?(:diagonal)
          moves_arr << [i, j] if !obstructed?(pos, [i,j]) && check_diagonals(i, j)
        end
      end
    end
    moves_arr
  end

  def check_straight(row, col)
    row == pos[0] || col == pos[1]
  end

  def check_diagonals(row, col)
    dx = row - pos[0]
    dy = col - pos[1]
    dx.abs == dy.abs
  end

  def obstructed?(start_pos, end_pos)
    x1, y1 = start_pos
    x2, y2 = end_pos
    dx = x2 <=> x1
    dy = y2 <=> y1
    until [x1, y1] == [x2 - dx, y2 - dy]
      return true if board.occupied?([x1, y1])
      x1 += dx
      y1 += dy
    end
    return false
  end

end

class Rook < SlidingPiece

  def move_dirs
    [:straight]
  end

  def to_s
    " \u265C ".colorize(@color)
  end

end

class Bishop < SlidingPiece

  def move_dirs
    [:diagonal]
  end

  def to_s
    " \u265D ".colorize(@color)
  end

end

class Queen < SlidingPiece

  def move_dirs
    [:straight, :diagonal]
  end

  def to_s
    " \u265B ".colorize(@color)
  end

end

class SteppingPiece < Piece

  def moves
    moves_arr = []
    MOVES.each do |move|
      dx, dy = move
      x, y = pos
      if (x + dx).between?(0, 7) && (y + dy).between?(0, 7)
        moves_arr << [x + dx, y + dy]
      end
    end
    moves
  end

end

class Knight < SteppingPiece

  MOVES = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

  def to_s
    " \u265E ".colorize(@color)
  end

end

class King < SteppingPiece

  MOVES = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
  ]

  def to_s
    " \u265A ".colorize(@color)
  end

end

class Pawn < Piece


  def moves

  end

  def to_s
    " \u265F ".colorize(@color)
  end

end
