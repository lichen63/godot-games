extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Configs.GROUP_NAME_SNAKE)
  self.name = Configs.NODE_NAME_SNAKE_HEAD

func _on_area_entered(area: Area2D) -> void:
  if area.is_in_group(Configs.GROUP_NAME_WALLS) or area.is_in_group(Configs.GROUP_NAME_SNAKE):
    #TODO: End the game with failure
    reset_pos()

func reset_pos() -> void:
  position = get_viewport().size / 2
