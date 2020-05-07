require 'ruby2d'

set width: 850
set height: 700
set background: '#dbd7d2'

class Worms

	
	def init
			#Спрашивать у пользователя
		@count_rule = 2    
		@rule_status = Array.new(@count_rule) { Array.new(6){elem = 0}}
		@start_point = [0, 0]
		@draw_start_point = []

		@rule_status[1][5] = 1
		@draw_path = []
		@count_real_rule = 0
		@last_position = [0, 0]
		@next_position = [0, 0]
		@direction = 0
		@rule = [2, 2]
		@condition = Array.new(@rule.size) { Array.new(6) {elem = 0}}
		@size_condition = 0
		@path = Array.new(2) { Array.new(2) { Array.new(6) {elem = 0} }}
		

	

	

	end

	def get_path
		@path
	end

	def find_next_position
		if @direction == 0
			@next_position[0] = @last_position[0] + 1

		elsif @direction == 5
			@next_position[1] -= 1 
			if @last_position[1] % 2 == 1 
				@next_position[0]= @last_position[0] + 1
			end

		elsif @direction == 4
			@next_position[1] = @last_position[1] - 1
			if @last_position[1] % 2 == 0 
				@next_position[0] = @last_position[0] - 1
			end

		elsif @direction == 3
			@next_position[0] = @last_position[0] - 1

		elsif @direction == 2
			@next_position[1] = @last_position[1] + 1
			if @last_position[1] % 2 == 0 
				@next_position[0] = @last_position[0] - 1
			end

		elsif @direction == 1
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

	def check_condition  
		number_rule = 0
		new_path = Array.new(6) {elem = 0}
		i = 0
		j = 0
		n = 1
		
		while i < 6
			if @path[@last_position[0]][@last_position[1]][i] == 'nil'
				@path[@last_position[0]][@last_position[1]][i] = 0
			end
			new_path[i] = ((i + @direction) % 6 ) * @path[@last_position[0]][@last_position[1]][i]

			i += 1
		end
		i = 0
		
		while i < @count_rule
			
			if new_path == @rule_status[i]
				return i
			end
			
			i += 1
 		end
 		if (@count_real_rule >= @count_rule)
 			#abort "End"
 			return 8
 		else
	 		@count_real_rule += 1
			@rule_status[@count_real_rule] = new_path 
			check_condition
		end
	end

	def change_path
		i = 0
		j = 0
		k = 0
		number = 0 
		
		if @start_point[1] % 2 == 1 
			@draw_start_point = [@start_point[0] * 100, @start_point[1] * 100 + 50]
		else 
			@draw_start_point = [(@start_point[0] - 1) * 100 + 50 , @start_point[1] * 100 + 50]
		end
		
		for i in 0..(@path.size - 1)
			for j in 0..(@path[0].size - 1)
				for k in 0..5 
					if @path[i][j][k] == 1
						if j % 2 == 1
							@draw_path[number] = [i * 100,  j * 100 + 50]
							
						else
							@draw_path[number] = [(i - 1) * 100  + 50, j * 100 + 50]
									
						end

						if k == 0
							@draw_path[number][2] = @draw_path[number][0] + 100
							@draw_path[number][3] = @draw_path[number][1]
						elsif k == 1
							@draw_path[number][2] = @draw_path[number][0] + 50
							@draw_path[number][3] = @draw_path[number][1] + 100
						elsif k == 2
							@draw_path[number][2] = @draw_path[number][0] - 50
							@draw_path[number][3] = @draw_path[number][1] + 100
						elsif k == 3
							@draw_path[number][2] = @draw_path[number][0] - 100
							@draw_path[number][3] = @draw_path[number][1]
						elsif k == 4
							@draw_path[number][2] = @draw_path[number][0] - 50
							@draw_path[number][3] = @draw_path[number][1] - 100
						elsif k == 5
							@draw_path[number][2] = @draw_path[number][0] + 50
							@draw_path[number][3] = @draw_path[number][1] - 100
						end
						number += 1
						#Line.new(x1: 100 , y1: 1000, x2: k + 100 , y2: 150, width: 4, color: '#a8a8a8')
					end
					k += 1
				end
				j += 1
			end
			i += 1
		end 
	end

	def draw
		
		size = @draw_path.size - 1
		for k in @draw_path
			Line.new(x1: k[0], y1: k[1], x2: k[2], y2: k[3], width: 4, color: '#a8a8a8')
		end	
		Circle.new(x: @draw_start_point[0], y: @draw_start_point[1], radius: 5, color: 'black')
		

	end

	def move(direction = 0)
		while true
			#определяется правило
			number = check_condition
			if number == 8
				return 0
			end

			number_rule = @rule[number] 
			
			#Исходя из правила находится следующая точка

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
				@start_point[0] += 2
				@start_point[1] += 2
			end
			
			# Заполнение путей и отрисовка
			path_filling
			#filling_field
			init_field
			change_path
			draw

			@last_position[0] = @next_position[0]
			@last_position[1] = @next_position[1]

		end
	end

end

def init_field 
	draw = []
	i = 50
		#Line.new(x1: i, y1: $j, x2: i + 50, y2: 150, width: 4, color: '#a8a8a8')
		while i < Window.width
			#Line.new(x1: i, y1: 50, x2: i + 50, y2: 150, width: 4, color: '#a8a8a8')
			Circle.new(x: i, y: 50, radius: 5, color: '#a8a8a8')
			
			Circle.new(x: i + 50, y: 150, radius: 5, color: '#a8a8a8')
			Circle.new(x: i, y: 250, radius: 5, color: '#a8a8a8')

			Circle.new(x: i + 50, y: 350, radius: 5, color: '#a8a8a8')
			Circle.new(x: i, y: 450, radius: 5, color: '#a8a8a8')

			Circle.new(x: i + 50, y: 550, radius: 5, color: '#a8a8a8')
			Circle.new(x: i, y: 650, radius: 5, color: '#a8a8a8')

			Circle.new(x: i + 50, y: 750, radius: 5, color: '#a8a8a8')
			Circle.new(x: i, y: 850, radius: 5, color: '#a8a8a8')
			

			i += 100
		end
end


one = Worms.new
one.init
#one.test_

one.move
#update do
	
	fully_path = one.get_path
	#init_field
	
	size = fully_path.size - 1
	size2 = fully_path[0].size - 1
	i = 0
	k = 0
	l = 0
	j = 0



#end


one.change_path


show

#изменить начальный статус