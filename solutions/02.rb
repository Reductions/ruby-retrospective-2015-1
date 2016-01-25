def move_space(*arrays)
  arrays.transpose.map{ |item| item.reduce(:+) }
end

def arena(start_with, width, height)
  width = Array.new(width)
  height = Array.new(height)
  width.map!.with_index{ |_, index| index + start_with }
  height.map!.with_index{ |_, index| index + start_with }
  width.product(height)
end

def obstacles(snake, dimensions)
  arena_with_walls = arena(-1, dimensions[:width] + 2, dimensions[:height] + 2)
  arena_inside = arena(0, dimensions[:width], dimensions[:height])
  arena_with_walls - arena_inside + snake.dup
end

def move(snake, direction)
  new_snake = snake.dup
  new_snake[1 .. -1].push(move_space(new_snake[-1], direction.dup))
end

def grow(snake, direction)
  new_snake = snake.dup
  new_snake.push(move_space(new_snake[-1], direction.dup))
end

def new_food(food, snake, dimensions)
  (arena(0, dimensions[:width], dimensions[:height]) - snake - food).shuffle[0]
end

def obstacle_ahead?(snake, direction, dimensions)
  obstacles(snake,dimensions).include?(move_space(snake[-1].dup, direction.dup))
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end
