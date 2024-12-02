extends RigidBody2D

const ANIMATION_PREFIX: String = "action_"

@onready var animated_sprite_: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
    animated_sprite_.animation = ANIMATION_PREFIX + str(randi() % 3 + 1)
    animated_sprite_.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
