def move_space(*arrays)
  arrays.transpose.map{ |item| item.reduce(:+) }
end

def arena(start_with, width, height)
  start_with.upto(start_with + height - 1).to_a.
    product(start_with.upto(start_with + width - 1).to_a)
end

def obstacles(snake, dimensions)
  arena(-1, dimensions[:width] + 2, dimensions[:height] + 2) -
    arena(0, dimensions[:width], dimensions[:height]) + snake
end

def move(snake, direction)
  snake[1 .. -1].push(move_space(snake[-1], direction))
end

def grow(snake, direction)
  snake.dup.push(move_space(snake[-1], direction))
end

def new_food(food, snake, dimensions)
  (arena(0, dimensions[:width], dimensions[:height]) - snake - food).shuffle[0]
end

def obstacle_ahead?(snake, direction, dimensions)
  obstacles(snake,dimensions).include?(move_space(snake[-1], direction))
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end
