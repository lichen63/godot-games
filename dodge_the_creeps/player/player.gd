extends Node2D

# Player actions defined in the Input Map
const PLAYER_ACTION_LEFT: String = "player_action_left"
const PLAYER_ACTION_RIGHT: String = "player_action_right"
const PLAYER_ACTION_UP: String = "player_action_up"
const PLAYER_ACTION_DOWN: String = "player_action_down"

# Player constants
const PLAYER_MOVE_SPEED: int = 200

@onready var animated_sprite_: AnimatedSprite2D = $Area2D/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func _physics_process(delta: float) -> void:
    var direction: Vector2 = Vector2(
        Input.get_action_strength(PLAYER_ACTION_RIGHT) - Input.get_action_strength(PLAYER_ACTION_LEFT),
        Input.get_action_strength(PLAYER_ACTION_DOWN) - Input.get_action_strength(PLAYER_ACTION_UP)
    )
    if direction.length() > 0:
        direction = direction.normalized()
        self.position += direction * PLAYER_MOVE_SPEED * delta
    animated_sprite_.play("left")

func update_animation(direction: Vector2) -> void:
    pass
