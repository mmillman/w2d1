require './board'

class Minesweeper

	def initialize(rows, cols, mines)
		@board = Board.new(rows, cols, mines)
	end

	def play(player)
		until game_over?
			command_type, x, y = player.move(@board.game_board)
			case command_type
			when :reveal then @board.reveal(x, y)
			when :flag then @board.toggle_flag(x, y)
			when :save then save
			end
		end
		player.blow_up if @board.stepped_on_mine?
		player.victory if @board.mines_sweeped?
	end

	def game_over?
		@board.stepped_on_mine? || @board.mines_sweeped?
	end

	def save

	end

	def load

	end

end

class Player
	attr_reader :name

	VALID_COMMANDS = {'f' => :flag, 'r' => :reveal}

	def move(board)
		board.each { |row| puts row.join(' ') }
		input = gets.chomp.split(' ')
		return VALID_COMMANDS[input[0]], input[1].to_i, input[2].to_i
	end

	def blow_up
		puts "u dead"
	end

	def victory
		puts "u win"
	end

end

Minesweeper.new(9, 9, 3).play(Player.new)