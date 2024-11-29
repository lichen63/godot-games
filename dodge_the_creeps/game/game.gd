extends Node2D


const ENEMY_SCENE: PackedScene = preload("res://enemy/enemy.tscn")

var score_: int = 0

@onready var spawn_enemy_timer_: Timer = $SpawnEnemyTimer
@onready var score_timer_: Timer = $ScoreTimer
@onready var ui_control_: Control = $UIControl

func _ready():
    spawn_enemy_timer_.start()
    score_timer_.start()

func _on_spawn_enemy_timer_timeout() -> void:
    add_child(ENEMY_SCENE.instantiate())

func _on_score_timer_timeout() -> void:
    score_ += 1
    ui_control_.update_score(score_)
