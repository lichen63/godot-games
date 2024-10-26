extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Configs.GROUP_NAME_FOODS)

# Set the random position
# Need to avoid walls, snake head and body
func move_to_random_pos() -> void:
  pass
  #var screen_size = get_viewport().size
    #var random_position = Vector2(
        #randf_range(0, screen_size.x),
        #randf_range(0, screen_size.y)
    #)
    #position = random_position  # 设置节点的位置
