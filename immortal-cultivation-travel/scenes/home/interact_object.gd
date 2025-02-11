class_name InteractObject
extends Area2D

const INTERACT_ANIMATION: String = "interactable"

@export var object_name_str: String = "Interactable"

@onready var object_name: Label = $ObjectName
@onready var interact_image: Sprite2D = $InteractSprite
@onready var interact_animation_player: AnimationPlayer = $InteractAnimationPlayer

func _ready() -> void:
    self.object_name.text = object_name_str
    self.interact_image.hide()
    self.interact_animation_player.stop()
    self.body_entered.connect(_on_body_entered)
    self.body_exited.connect(_on_body_exited)

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
