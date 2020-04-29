
class Worms

	@@count_rule
	@@rule_status
	def init
			#Спрашивать у пользователя
		@@count_rule = 2    
		@@rule_status = Array.new(@@count_rule) { Array.new(6){elem = 0}}
		
		@@rule_status[1][5] = 1
		p @@rule_status
		@last_position = [0, 0]
		@next_position = [0, 0]
		@direction = 0
		@rule = [2, 2]
		@condition = Array.new(@rule.size) { Array.new(6) {elem = 0}}
		@size_condition = 0
		@path = Array.new(2) { Array.new(2) { Array.new(6) {elem = 0} }}
		@x = 0
		@y = 0

	

	

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
		#puts @direction
	end

	def path_filling
		@path[@last_position[0]][@last_position[1]][@direction] = 1
		@path[@next_position[0]][@next_position[1]][(@direction + 3) % 6] = 1   
	end

	def add_size_up
		@path.push(Array.new(2) { Array.new(3) }) #add x
		i = 0
		while i < @path.size  #add y
			@path[i].push( Array.new(3) {elem = 0} )
			i += 1
		end
	end

	def add_size_down
		
		@path.insert(0, Array.new(2) { Array.new(6) {elem = 0}})
		i = 0
		while i < @path.size
			@path[i].insert(0, Array.new(6) {elem = 0})
			i += 1
		end

	end

	#Add size left and right

	#Rename on find rule
	def check_condition  
		number_rule = 0
		new_path = Array.new(6) 
		i = 0
		j = 0
		n = 1
		print "last "
		p @path[@last_position[0]][@last_position[1]]
		while i < 6
			if @path[@last_position[0]][@last_position[1]][i] == 'nil'
				@path[@last_position[0]][@last_position[1]][i] = 0
			end
			new_path[i] = ((i + @direction) % 6 ) * @path[@last_position[0]][@last_position[1]][i]

			i += 1
		end
		print "New path"
		p new_path
		i = 0
		p (@direction + 3) % 6
		while i < @@count_rule
			
			if new_path == @@rule_status[i]
				puts "true"

				return i
			end
			
			i += 1
 		end
 		abort "End"
		
	end

	def move(direction = 0)
		print "Rules: "
		p @rule

		puts "first_position: [2, 2] "
	
		while true
			i = 0
			while i < 6
				@condition[@size_condition][i] = @path[@last_position[0]][@last_position[1]][i]     ## Общее 
				i += 1
			end
			number_rule = @rule[check_condition] 
			print "number_rule = "
			puts number_rule
			
				#Добавить поиск правила
				
			
			find_direction(number_rule)

			find_next_position
			#Увеличение поля
			if (@next_position[0] < 0 || @next_position[1] < 0)
				add_size_down
				add_size_down
				@next_position[0] += 2
				@next_position[1] += 2
				@last_position[0] += 2
				@last_position[1] += 2
			end
			

			path_filling
			p @path[@last_position[0]][@last_position[1]]
			print "last_position :"
			p @last_position
			print "next_position: "
			p @next_position
			@last_position[0] = @next_position[0]
			@last_position[1] = @next_position[1]
			p @path[@last_position[0]][@last_position[1]]
		
		#elsif @size_condition < @rule.size
		#	return 0
		#	@size_condition += 1
		#	i = 0
		#	while i < 6
		#		@condition[@size_condition][i] = @path[@next_position[0]][@next_position[1]][i]
		#		i += 1
		#	end
			#puts "these 1"
	

		end


		#p @path
	end

	def test_
		p @path
		add_size_down
		puts "After "
		p @path
	end

end

one = Worms.new
one.init
#one.test_
one.move

