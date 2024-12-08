extends CharacterBody2D

const RUN_SPEED: float = 160.0
const ACCELERATION_FLOOR: float = RUN_SPEED / 0.2
const ACCELERATION_AIR: float = RUN_SPEED / 0.02
const JUMP_VELOCITY: float = -360.0

var gravity_: float = ProjectSettings.get("physics/2d/default_gravity")

@onready var sprite_: Sprite2D = $Sprite
@onready var animation_player_: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer_: Timer = $CoyoteTimer
@onready var jump_request_timer_: Timer = $JumpRequestTimer

func _physics_process(delta: float) -> void:
    var direction: float = Input.get_axis("move_left", "move_right")
    var acceleration: float = ACCELERATION_FLOOR if self.is_on_floor() else ACCELERATION_AIR
    self.velocity.x = move_toward(self.velocity.x, direction * RUN_SPEED, acceleration * delta)
    self.velocity.y += gravity_ * delta

    var can_jump: bool = self.is_on_floor() or coyote_timer_.time_left > 0
    var should_jump: bool = can_jump and jump_request_timer_.time_left > 0
    if should_jump:
        self.velocity.y = JUMP_VELOCITY
        coyote_timer_.stop()
        jump_request_timer_.stop()

    if self.is_on_floor():
        if is_zero_approx(direction) and is_zero_approx(self.velocity.x):
            animation_player_.play("idle")
        else:
            animation_player_.play("running")
    else:
        animation_player_.play("jump")

    if not is_zero_approx(direction):
        sprite_.flip_h = direction < 0

    var was_on_floor: bool = self.is_on_floor()
    self.move_and_slide()
    
    if self.is_on_floor() != was_on_floor:
        if self.is_on_floor() and not should_jump:
            coyote_timer_.start()
        else:
            coyote_timer_.stop()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
        jump_request_timer_.start()
    if event.is_action_released("jump") and self.velocity.y < JUMP_VELOCITY / 2:
        self.velocity.y = JUMP_VELOCITY / 2
