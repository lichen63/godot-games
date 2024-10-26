extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.add_to_group(Configs.GROUP_NAME_WALLS)
