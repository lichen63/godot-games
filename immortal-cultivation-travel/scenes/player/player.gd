class_name Player
extends CharacterBody2D

const MOVE_SPEED: float = 500.0
const ANIMATION_IDLE: String = "idle"
const ANIMATION_RUN: String = "run"
const ANIMATION_ATTACK: String = "attack"
const ANIMATION_DEAD: String = "dead"
const INPUT_ACTION_LEFT: String = "player_left"
const INPUT_ACTION_RIGHT: String = "player_right"
const INPUT_ACTION_UP: String = "player_up"
const INPUT_ACTION_DOWN: String = "player_down"
const INPUT_ACTION_ACCEPT: String = "player_accept"

var gravity: float = ProjectSettings.get("physics/2d/default_gravity") as float
var interacting_with: Array[Interactable] = []

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
  self.animated_sprite.animation = ANIMATION_IDLE
  self.animated_sprite.play()

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed(INPUT_ACTION_ACCEPT) and not self.interacting_with.is_empty():
    self.interacting_with.back().interact()

func _physics_process(delta: float) -> void:
  self.velocity.y += gravity * delta
  var direction: float = Input.get_axis(INPUT_ACTION_LEFT, INPUT_ACTION_RIGHT)
  self.velocity.x = direction * MOVE_SPEED
  if not is_zero_approx(direction):
    self.animated_sprite.animation = ANIMATION_RUN
    self.animated_sprite.flip_h = is_equal_approx(direction, -1)
  else:
    self.animated_sprite.animation = ANIMATION_IDLE
  self.move_and_slide()

func register_interact_object(obj: Interactable) -> void:
  self.interacting_with.append(obj)

func unregister_interact_object(obj: Interactable) -> void:
  self.interacting_with.erase(obj)
