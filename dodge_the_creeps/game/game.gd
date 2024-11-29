extends Node2D

var enemy_scene_: PackedScene = preload("res://enemy/enemy.tscn")

@onready var spawn_enemy_timer_: Timer = $SpawnEnemyTimer

func _ready():
    spawn_enemy_timer_.start()

func _on_spawn_enemy_timer_timeout() -> void:
    add_child(enemy_scene_.instantiate())
