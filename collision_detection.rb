require 'ruby2d'

set background: 'white'
set width: 1200
set height: 800

class Box
  def initialize
    @x = rand(Window.width)
    @y = rand(Window.height)
    @x_velocity = (-5..5).to_a.sample
    @y_velocity = (-5..5).to_a.sample
    @color = Color.new('random')
    @size = (6..20).to_a.sample
  end

  def draw
    @square = Square.new(x: @x, y: @y, size: @size, color: @color)
  end

  def move
    @x = (@x + @x_velocity) % Window.width
    @y = (@y + @y_velocity) % Window.height
  end


end

$boxes = Array.new(40) { Box.new }

update do
  clear
  $boxes.each do |box|
    
    box.move
    box.draw
  end
end

show
