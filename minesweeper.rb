class Minesweeper

	def initialize(rows, cols, mines)
	end

	def play(player)
		until game_over?
			move = player.move(board)
			board.make_move(move)
		end
	end

	def game_over?

	end

end

class Board

	def initialize(row, cols, mines)

	end

end

class Player
	attr_reader :name

	def move(board)

	end

end