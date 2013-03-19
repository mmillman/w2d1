class HighScore
	def initialize
		@high_scores = []
	end

	def top_ten
		@high_scores
	end

	def insert_score(seconds, player_name)
		@high_scores << [seconds, player_name]
		@high_scores.sort! { |s1, s2| s1.first <=> s2.first }
<<<<<<< HEAD
		#REV nice and simple, I like this logic on keeping the list at 10.
=======
>>>>>>> 75d5ad21bff76320e41ebe7f48b80988274298cb
		while @high_scores.length > 10
			@high_scores.pop
		end
	end
end