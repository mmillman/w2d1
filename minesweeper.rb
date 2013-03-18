require './board'

class Minesweeper

	def initialize(rows, cols, mines)
		@board = Board.new(rows, cols, mines)
	end

	def play(player)
		until game_over?
			move_type, x, y = player.move(@board.game_board)
			if move_type == :reveal
				@board.reveal(x, y)
			elsif move_type == :flag
				@board.toggle_flag(x, y)
			end
		end
	end

	def game_over?
		false
	end

end

class Player
	attr_reader :name

	VALID_COMMANDS = {'f' => :flag, 'r' => :reveal}

	def move(board)
		board.each { |row| p row }
		input = gets.chomp.split(' ')
		return VALID_COMMANDS[input[0]], input[1].to_i, input[2].to_i
	end

end

Minesweeper.new(9, 9, 10).play(Player.new)