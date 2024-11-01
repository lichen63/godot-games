extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Configs.GROUP_NAME_SNAKE)

func set_properties(body_index: int) -> void:
  set_name(Configs.NODE_NAME_SNAKE_BODY_PREFIX + str(body_index))
