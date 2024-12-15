class_name Enemy
extends CharacterBody2D

enum Direction {
    LEFT = -1,
    RIGHT = +1,
}

@export var direction: Direction = Direction.RIGHT:
    set(v):
        direction = v
        if not self.is_node_ready():
            await self.ready
        self.graphics.scale.x = -direction
@export var max_speed: float = 180
@export var acceleration: float = 2000

var default_gravity: float = ProjectSettings.get("physics/2d/default_gravity")

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var stats: Stats = $Stats

func _ready() -> void:
    self.add_to_group("enemies")

func move(speed: float, delta: float) -> void:
    self.velocity.x = move_toward(self.velocity.x, speed * self.direction, self.acceleration * delta)
    self.velocity.y += self.default_gravity * delta
    self.move_and_slide()

func die() -> void:
    self.queue_free()
