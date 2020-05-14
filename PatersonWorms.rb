require 'ruby2d'

set width: 850
set height: 700
set background: '#dbd7d2'

class Worms

	
	def init
			#Спрашивать у пользователя
		
		
		@start_point =  [0, 0]   

		puts "Введите правила"
		enter = gets.chomp
		@rule = enter.chars.map {|c| c.to_i }
		p @rule
		@count_rule = @rule.size    
		@rule_status = Array.new(@count_rule) { Array.new(6){elem = 0}}
		@count_real_rule = 2
		@rule_status[1][3] = 1
		

		@draw_path = []
		@draw_start_point = @start_point
		
		puts "Введите начальную точку [x, y]"
		enter = gets.chomp
		@last_position = enter.chars.map {|c| c.to_i }
		@next_position = [0, 0]
		@direction = 0
		
		@condition = Array.new(@rule.size) { Array.new(6) {elem = 0}}
		@size_condition = 0
		@path = Array.new(5) { Array.new(5) { Array.new(6) {elem = 0} }}

		@color = "#%06x" % (rand * 0xffffff)

	

	end

	def get_path
		@path
	end

	def find_next_position
		if @direction == 0
			@next_position[0] = @last_position[0] + 1
		elsif @direction == 1
			@next_position[1] = @last_position[1] + 1
			if @last_position[1] % 2 == 1 
				@next_position[0] = @last_position[0] + 1
			end
		elsif @direction == 2
			@next_position[1] = @last_position[1] + 1
			if @last_position[1] % 2 == 0 
				@next_position[0] = @last_position[0] - 1
			end
		elsif @direction == 3
			@next_position[0] = @last_position[0] - 1
		elsif @direction == 4
			@next_position[1] = @last_position[1] - 1
			if @last_position[1] % 2 == 0 
				@next_position[0] = @last_position[0] - 1
			end
		elsif @direction == 5
			@next_position[1] -= 1 
			if @last_position[1] % 2 == 1 
				@next_position[0]= @last_position[0] + 1
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
	
		@path.push(Array.new(@path.size) { Array.new(6) {elem = 0} }) #add x
		i = 0
		while i < @path.size  #add y
			@path[i].push( Array.new(6) {elem = 0} )
			i += 1
		end

		
	end

	def add_size_down
	
		@path.insert(0, Array.new(@path.size) { Array.new(6) {elem = 0}})
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
			
			if @path[@last_position[0]][@last_position[1]][i] == 1
				n = i - @direction  
				new_path[(n.abs % 6 )] =  1 
			end
			

			i += 1
		end
		i = 0
		
		while i < @count_rule
			#puts "count_rule: #{@count_real_rule}"
		
			if new_path == @rule_status[i]
				return i
			end
			
			i += 1
 		end
 		if (@count_real_rule == @count_rule)
 			return 8
 		else
			@rule_status[@count_real_rule] = new_path 
			@count_real_rule += 1
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
			Line.new(x1: k[0], y1: k[1], x2: k[2], y2: k[3], width: 4, color: @color)
		end	
		Circle.new(x: @draw_start_point[0], y: @draw_start_point[1], radius: 5, color: 'black')
		

	end

	def move(direction = 0)
		
			#определяется правило
			number = check_condition
			
			if number == 8
				return 1
			end
			#Исходя из правила находится следующая точка

			find_direction(@rule[number])
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
			if (@next_position[0] >= @path.size || @next_position[1] >= @path[0].size)
				add_size_up
				add_size_up
			end
			
			# Заполнение путей и отрисовка
			path_filling
			#filling_field
			
			change_path
			draw


			@last_position[0] = @next_position[0]
			@last_position[1] = @next_position[1]

			return 0
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

count_player = 2

one = Worms.new
two = Worms.new

init_field



one.init
two.init


 while true
	if (one.move && two.move) == 1
		break
	end
 end



show

#изменить начальный статус