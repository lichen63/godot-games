class_name Player
extends CharacterBody2D

const SPEED: float = 500.0
const ANIMATION_IDLE: String = "idle"
const ANIMATION_RUN: String = "run"
const ANIMATION_ATTACK: String = "attack"
const ANIMATION_DEAD: String = "dead"
const INPUT_ACTION_LEFT: String = "player_left"
const INPUT_ACTION_RIGHT: String = "player_right"
const INPUT_ACTION_UP: String = "player_up"
const INPUT_ACTION_DOWN: String = "player_down"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
    self.animated_sprite.animation = ANIMATION_IDLE
    self.animated_sprite.play()

func _physics_process(_delta: float) -> void:
    var direction = Vector2.ZERO

    if Input.is_action_pressed(INPUT_ACTION_LEFT):
        direction.x -= 1
    if Input.is_action_pressed(INPUT_ACTION_RIGHT):
        direction.x += 1
    if Input.is_action_pressed(INPUT_ACTION_UP):
        direction.y -= 1
    if Input.is_action_pressed(INPUT_ACTION_DOWN):
        direction.y += 1

    direction = direction.normalized()
    self.velocity = direction * SPEED

    if direction != Vector2.ZERO:
        self.animated_sprite.animation = ANIMATION_RUN
        if not is_zero_approx(direction.x):
            self.animated_sprite.flip_h = direction.x < 0
    else:
        self.animated_sprite.animation = ANIMATION_IDLE

    self.move_and_slide()
