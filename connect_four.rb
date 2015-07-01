
class Board
  attr_accessor :board

  def initialize
    @board = Array.new(7) { Array.new(6, "▢") }
  end

  def drop_piece(row)
    position = board[row].find_index("▢")
    position.nil? ? false : board[row][position] = Game.current_player.piece
  end

end

class Player
  attr_reader :piece, :name

  def initialize(name, piece = '☃')
    @piece = piece
    @name = name
  end

end

module Game

  @@players = [Player.new("Player 1", "☃"), Player.new("Player 2", "☠")]
  @@gameover = false

  def self.current_player
    @@players[0]
  end

  def self.next_player
    @@players.rotate!
  end

  def self.gameover?
    @@gameover
  end

  def self.rotate_board(board)
    board.map { |row| row.reverse }.transpose
  end

  def self.display_board(board)
    puts "1  2  3  4  5  6  7"
    board.each_index do |y|
      board[y].each_index do |x|
        print "#{board[y][x]}  "
      end
      puts
    end
  end

  def self.get_user_input
    input = 0
    while input < 1 || input > 7
      print "#{@@players[0].name}'s Turn: "
      input = gets.chomp.to_i
    end
    input - 1
  end

  def self.check_vertical_win(board)
    board.each do |row|
      string = row.join("")
      if string.match(/(☃{4}|☠{4})/)
        @@gameover = true
      end
    end
  end

  def self.check_horizontal_win(board)
    board.transpose.each do |row|
      string = row.join("")
      if string.match(/(☃{4}|☠{4})/)
        @@gameover = true
      end
    end
  end

  def self.check_up_right_win(board)
    board.each_index do |y|
      board[y].each_index do |x|
        unless board[y+3].nil?
          @@gameover = true if board[y][x] == board[y+1][x+1] &&
          board[y][x] == board[y+2][x+2] &&
          board[y][x] == board[y+3][x+3] &&
          board[y][x] != '▢'
        end
      end
    end
  end

  def self.check_up_left_win(board)
    board.each_index do |y|
      board[y].each_index do |x|
        unless board[y+3].nil?
          @@gameover = true if board[y][x] == board[y+1][x-1] &&
          board[y][x] == board[y+2][x-2] &&
          board[y][x] == board[y+3][x-3] &&
          board[y][x] != '▢'
        end
      end
    end
  end

  def self.check_win(board)
    check_vertical_win(board)
    check_horizontal_win(board)
    check_up_left_win(board)
    check_up_right_win(board)
  end

  def self.player_win
    puts "#{current_player.name} wins!"
  end

end

connect_four = Board.new

def run_game(connect_four)
  until Game.gameover?
    system('clear')
    Game.display_board(Game.rotate_board(connect_four.board))
    until connect_four.drop_piece(Game.get_user_input)
    end
    Game.check_win(connect_four.board)
    Game.next_player unless Game.gameover?
  end
  system('clear')
  Game.display_board(Game.rotate_board(connect_four.board))
  Game.player_win
end

run_game(connect_four)
