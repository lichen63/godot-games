extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Configs.GROUP_NAME_SNAKE)
  self.name = Configs.NODE_NAME_SNAKE_HEAD

#func _on_area_entered(area: Area2D) -> void:
  #if area.is_in_group(Configs.GROUP_NAME_WALLS) or area.is_in_group(Configs.GROUP_NAME_SNAKE):
    #if area.name != Configs.NODE_NAME_SNAKE_BODY_PREFIX + "1" and area.name != Configs.NODE_NAME_SNAKE_BODY_PREFIX + "2":
      ##TODO: End the game with failure
      #reset_pos()
      #Logger.info("Game Over!")

func reset_pos() -> void:
  position = get_viewport().size / 2
