class_name Interactable
extends Area2D

const INTERACT_ANIMATION: String = "interactable"
const NAME_ATTRIBUTES: String = "Attributes"
const NAME_MYTERIOUS: String = "Myterious"

@export var object_name_str: String = "Interactable"
@export_file("*.png") var object_res_str: String = ""

@onready var object_name: Label = $ObjectName
@onready var object_sprite: Sprite2D = $ObjectSprite
@onready var interact_image: Sprite2D = $InteractSprite
@onready var interact_animation_player: AnimationPlayer = $InteractAnimationPlayer

func _ready() -> void:
  self.object_name.text = object_name_str
  if not object_res_str.is_empty():
    self.object_sprite.texture = load(self.object_res_str)
  self.interact_image.hide()
  self.interact_animation_player.stop()

func _on_body_entered(body: Node2D) -> void:
  if not body is Player:
    return
  self.interact_image.show()
  self.interact_animation_player.play(INTERACT_ANIMATION)
  body.register_interact_object(self)

func _on_body_exited(body: Node2D) -> void:
  if not body is Player:
    return
  self.interact_image.hide()
  self.interact_animation_player.stop()
  body.unregister_interact_object(self)

func interact() -> void:
  print("[Interact] %s" % self.name)
  match name:
    NAME_ATTRIBUTES:
      pass
    NAME_MYTERIOUS:
      self.get_tree().change_scene_to_file("res://scenes/myterious/myterious.tscn")
    _:
      pass
