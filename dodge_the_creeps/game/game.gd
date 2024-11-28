extends Node2D

var enemy_scene = preload("res://enemy/enemy.tscn")
var spawn_interval = 1.5

func _ready():
    var timer = Timer.new()
    timer.wait_time = spawn_interval
    timer.autostart = true
    timer.timeout.connect(_spawn_enemy)
    add_child(timer)

func _spawn_enemy():
    var enemy = enemy_scene.instantiate()
    add_child(enemy)
