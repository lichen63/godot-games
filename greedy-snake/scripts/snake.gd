extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var snake_body_scene = load("res://scenes/snake_body.tscn")
  var snake_body_instance = snake_body_scene.instantiate()
  snake_body_instance.position = Vector2(-30, 0)
  self.add_child(snake_body_instance)
  
  var children = self.get_children()
