class_name Player
extends CharacterBody2D

const MOVE_SPEED: float = 800.0
const ACCELERATION_FLOOR: float = MOVE_SPEED / 0.2
const ACCELERATION_AIR: float = MOVE_SPEED / 0.1
const JUMP_VELOCITY: float = -800.0
const ANIMATION_IDLE: String = "idle"
const ANIMATION_RUN: String = "run"
const ANIMATION_ATTACK: String = "attack"
const ANIMATION_DEAD: String = "dead"

var gravity: float = ProjectSettings.get("physics/2d/default_gravity") as float
var interacting_with: Array[Interactable] = []

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
  self.animated_sprite.animation = ANIMATION_IDLE
  self.animated_sprite.play()

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("player_interact") and not self.interacting_with.is_empty():
    self.interacting_with.back().interact()

func _physics_process(delta: float) -> void:
  # set velocity of x
  var direction: float = Input.get_axis("player_left", "player_right")
  var acceleration: float = ACCELERATION_FLOOR if self.is_on_floor() else ACCELERATION_AIR
  self.velocity.x = move_toward(self.velocity.x, direction * MOVE_SPEED, acceleration * delta)

  # set velocity of y
  self.velocity.y += gravity * delta
  if self.is_on_floor() and Input.is_action_pressed("player_jump"):
    self.velocity.y = JUMP_VELOCITY

  # set animation
  if not is_zero_approx(direction):
    self.animated_sprite.animation = ANIMATION_RUN
    self.animated_sprite.flip_h = is_equal_approx(direction, -1)
  else:
    self.animated_sprite.animation = ANIMATION_IDLE

  # start move
  self.move_and_slide()

func register_interact_object(obj: Interactable) -> void:
  self.interacting_with.append(obj)

func unregister_interact_object(obj: Interactable) -> void:
  self.interacting_with.erase(obj)
