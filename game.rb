require './Chess_board.rb'

class ChessGame
  attr_accessor :board
  def initialize
    @board = ChessBoard.new
    return nil
  end

  def game_loop
    color = :w
    board.show
    until board.check_mated?(:b) || board.check_mated?(:w)

      begin
        start_pos, end_pos = get_user_input(color)
        raise ArgumentError unless board[start_pos].color == color
      rescue
        board.show
        puts "\tInvalid move!"
        retry
      end
      board.move(start_pos,end_pos)
      color = color == :w ? :b : :w
    end
  end

  def validate_move #check format and make sure move is possible
    return true
  end

  def get_user_input(color)
    valid = false
    until valid
      puts "\t#{color}'s turn to move."
      printf "\tFormat [0,0]-[0,1]: "
      move = gets.chomp.split("-").map { |pos| eval(pos) } #DO NOT KEEP
      valid = validate_move
    end
    move
  end

end