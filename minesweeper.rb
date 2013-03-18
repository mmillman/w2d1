require './board'

class Minesweeper

	def initialize(rows, cols, mines)
		@board = Board.new(rows, cols, mines)
	end

	def play(player)
		until game_over?
			move = player.move(@board.game_board)
			@board.make_move(move)
		end
	end

	def game_over?

	end

end

class Player
	attr_reader :name

	def move(board)
		board.each { |row| p row }

		input = gets.chomp.split(' ')

	end

end

Minesweeper.new(9, 9, 10).play(Player.new)