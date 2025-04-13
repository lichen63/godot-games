extends Area2D

@export_file("*.png") var monster_res_str: String = ""

@onready var monster_sprite: Sprite2D = $"Sprite"

func _ready() -> void:
  if not monster_res_str.is_empty():
    self.monster_sprite.texture = load(self.monster_res_str)

func _on_body_entered(body: Node2D) -> void:
  if not body is Player:
    return

func _on_body_exited(body: Node2D) -> void:
  if not body is Player:
    return
