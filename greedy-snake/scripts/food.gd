extends Area2D

const POSITION_RANDOM_COUNT_LIMIT:int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Configs.GROUP_NAME_FOODS)
  move_to_random_pos()

# Set the random position
# Need to avoid walls, snake head and body
func move_to_random_pos() -> void:
  var snake_nodes:Array[Node] = get_tree().get_nodes_in_group(Configs.GROUP_NAME_SNAKE)
  var snake_positions:Array[Vector2]
  for snake_node in snake_nodes:
    snake_positions.append(snake_node.position)
  var random_counts:int = 0
  var random_position:Vector2 = generate_random_pos()
  while (check_has_conflict(snake_positions, random_position)):
    random_counts += 1
    random_position = generate_random_pos()
    if (random_counts >= POSITION_RANDOM_COUNT_LIMIT):
      break
  if (random_counts < POSITION_RANDOM_COUNT_LIMIT):
    self.position = random_position
  else:
    # TODO: End the game with success
    pass

# Check if the random position is conflict with snake nodes
func check_has_conflict(snake_positions:Array[Vector2], random_pos:Vector2) -> bool:
  var conflict:bool = false
  for snake_pos in snake_positions:
    if (random_pos.is_equal_approx(snake_pos)):
      conflict = true
      break
  return conflict

# Generate a random position within the limit of walls
func generate_random_pos() -> Vector2:
  var screen_size = get_viewport().size
  var random_position = Vector2(
      randf_range(Configs.WALL_WIDTH, screen_size.x - Configs.WALL_WIDTH),
      randf_range(Configs.WALL_WIDTH, screen_size.y - Configs.WALL_WIDTH)
  )
  return random_position
