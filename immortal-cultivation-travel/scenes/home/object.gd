extends Area2D

@onready var interact_image: Sprite2D = $InteractSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    self.interact_image.hide()
    self.animation_player.stop()

func _on_body_entered(body: Node2D) -> void:
    if not body is Player:
        return
    self.interact_image.show()
    self.animation_player.play("interactable")

func _on_body_exited(body: Node2D) -> void:
    if not body is Player:
        return
    self.interact_image.hide()
    self.animation_player.stop()
