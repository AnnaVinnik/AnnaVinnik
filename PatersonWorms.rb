class Worms
	def init
		@last_position = [0, 0]
		@next_position = [0, 0]
		@direction = 0
		@path = Array.new(3) { Array.new(4) { Array.new(5) }}
		@x = 0
		@y = 0
		#p @path

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
		@direction = (@direction + new_direction) % 6
		puts @direction
	end

	def path_filling
		@path[@last_position[0]][@last_position[1]][@direction] = 1
		@path[@next_position[0]][@next_position[1]][(@direction + 3) % 6] = 1
		p @last_position
		p @next_position
	end

	def move(direction = 0)
		find_direction(5)
		find_next_position
		path_filling
		p @path
	end

end

one = Worms.new
one.init
one.move