extends CharacterBody2D

const RUN_SPEED: float = 200.0
const JUMP_VELOCITY: float = -300.0

var gravity_: float = ProjectSettings.get("physics/2d/default_gravity")

@onready var sprite_: Sprite2D = $Sprite
@onready var animation_player_: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
    var direction: float = Input.get_axis("move_left", "move_right")
    self.velocity.x = direction * RUN_SPEED
    self.velocity.y += gravity_ * delta
    
    if self.is_on_floor() and Input.is_action_just_pressed("jump"):
        self.velocity.y = JUMP_VELOCITY

    if self.is_on_floor():
        if is_zero_approx(direction):
            animation_player_.play("idle")
        else:
            animation_player_.play("running")
    else:
        animation_player_.play("jump")

    if not is_zero_approx(direction):
        sprite_.flip_h = direction < 0

    self.move_and_slide()
