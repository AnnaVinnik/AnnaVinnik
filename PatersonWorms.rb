class Worms
	def init
		@last_position = [0, 0]
		@next_position = [0, 0]
		@arm = Array.new(3) { Array.new(4) { Array.new(5) }}
		@x = 0
		@y = 0
		#p @arm

	end

	def find_next_position
		if @direction == 0
			@next_position[0] = @last_position[0] + 1

		elsif @direction == 1
			@next_position[1] -= 1 
			if @last_position[1] % 2 == 1 
				@next_position[0]= @last_position[0] + 1
			end

		elsif @direction == 2
			@next_position[1] = @last_position[1] - 1
			if @last_position[1] % 2 == 0 
				@next_position[0] = @last_position[0] - 1
			end

		elsif @direction == 3
			@next_position[0] = @last_position[0] - 1

		elsif @direction == 4
			@next_position[1] = @last_position[1] + 1
			if @last_position[1] % 2 == 0 
				@next_position[0] = @last_position[0] - 1
			end

		elsif @direction == 5
			@next_position[1] = @last_position[1] + 1
			if @last_position[1] % 2 == 1 
				@next_position[0] = @last_position[0] + 1
			end
						
		end
	end

	def find_direction(new_direction)

	end

	def move(direction = 0)
		if direction == 0
			#@position = @position
		end

	end

end

one = Worms.new
one.init