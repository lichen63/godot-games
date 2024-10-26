extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Configs.GROUP_NAME_FOODS)
  move_to_random_pos()

# Set the random position
# Need to avoid walls, snake head and body
func move_to_random_pos() -> void:
  var screen_size = get_viewport().size
  var random_position = Vector2(
      randf_range(Configs.WALL_WIDTH, screen_size.x - Configs.WALL_WIDTH),
      randf_range(Configs.WALL_WIDTH, screen_size.y - Configs.WALL_WIDTH)
  )
  position = random_position
