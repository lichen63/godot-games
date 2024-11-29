extends Node2D

var enemy_scene_: PackedScene = preload("res://enemy/enemy.tscn")
var spawn_enemy_interval_ = 1

func _ready():
    var timer = Timer.new()
    timer.wait_time = spawn_enemy_interval_
    timer.autostart = true
    timer.timeout.connect(_spawn_enemy)
    add_child(timer)

func _spawn_enemy():
    add_child(enemy_scene_.instantiate())
