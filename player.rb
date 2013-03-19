class Player
	attr_reader :name

	VALID_COMMANDS = {'f' => :flag, 'r' => :reveal, 's' => :save, 'q' => :quit, 'hs' => :highscore }

	def initialize(name)
		@name = name
	end

	def move(board, seconds)
		print_board(board)
		puts "time: #{seconds.to_i}s. 'r x y' to reveal, 'f x y' to flag, hs for high scores, s to save, q to quit"
		input = gets.chomp.split(' ')

		return nil unless VALID_COMMANDS.include?(input[0])
		return VALID_COMMANDS[input[0].downcase], input[1].to_i, input[2].to_i
	end

	def blow_up(board)
		print_board(board)
		puts "u dead"
	end

	def print_board(board)
		puts "     " + 0.upto(board[0].length - 1).map { |i| i.to_s.rjust(2)}.join(' ')
		puts "    " + "-" * board[0].length * 3 + "--"

		board.each_with_index { |row, index| puts " #{index.to_s.rjust(2)} | " + row.join('  ') + " |" }

		puts "    " + "-" * board[0].length * 3 + "--"
	end

	def victory(board)
		print_board(board)
		puts "u win"
	end

	def update_timer(seconds)
		p seconds
	end

	def display_high_score(scores)
		print "high score: "
		p scores
	end

end