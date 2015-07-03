require 'colorize'

class Piece
  attr_reader :pos, :color, :board

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @moved = false
  end

  def occupied?
    return true
  end

  def empty?
    return false
  end

end

class SlidingPiece < Piece

  STRAIGHT_VECTORS = [[1,0],[-1,0],[0,1],[0,-1]]
  DIAGONAL_VECTORS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]

  def moves
    s_moves = straight_moves if move_dirs.include?(:straight)
    d_moves = diagonal_moves if move_dirs.include?(:diagonal)
    # p s_moves
    # p d_moves
    (s_moves || []) + (d_moves || [])
  end

  def straight_moves
    moves_arr = []
    STRAIGHT_VECTORS.each do |vector|
      new_pos = [pos[0] + vector[0], pos[1] + vector[1]]
      until !board.on_board?(new_pos)
        moves_arr << new_pos.dup unless @board[new_pos].color == color
        break if board.occupied?(new_pos)
        new_pos[0] += vector[0]
        new_pos[1] += vector[1]
      end
    end
    p moves_arr
    moves_arr
  end

  def diagonal_moves
    moves_arr = []
    DIAGONAL_VECTORS.each do |vector|
      new_pos = [pos[0] + vector[0], pos[1] + vector[1]]
      until !board.on_board?(new_pos)
        moves_arr << new_pos.dup unless @board[new_pos].color == color
        break if board.occupied?(new_pos)
        new_pos[0] += vector[0]
        new_pos[1] += vector[1]
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
    move_dirs.each do |move|
      dx, dy = move
      x, y = pos
      if (x + dx).between?(0, 7) && (y + dy).between?(0, 7)
        moves_arr << [x + dx, y + dy] unless @board[[x + dx, y + dy]].color == color
      end
    end
    moves_arr
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

  def move_dirs
    MOVES
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

  def move_dirs
    MOVES
  end

end

class Pawn < Piece

  def moves
    moves_arr = []
    p multiplier = color == :white ? 1 : -1
    multiplier = color == :white ? 1 : -1
    if @moved
      moves_arr << [pos[0] + (1 * multiplier), pos[1]]
    else
      moves_arr << [pos[0] + (1 * multiplier), pos[1]]
      moves_arr << [pos[0] + (2 * multiplier), pos[1]]
      @moved = true
    end
    x = pos[0] + (1 * multiplier)
    y1 = pos[1] - 1
    y2 = pos[1] + 1
    if y1.between?(0, 7)
      moves_arr << [x, y1] if board[[x, y1]].color != color && board.occupied?([x, y1])
    end
    if y2.between?(0, 7)
      moves_arr << [x, y2] if board[[x, y2]].color != color && board.occupied?([x, y2])
    end
    moves_arr
  end

  def to_s
    " \u265F ".colorize(@color)
  end

end
