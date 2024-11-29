extends Node2D

const ENEMY_SCENE: PackedScene = preload("res://enemy/enemy.tscn")

var score_: int = 0
var game_state_: Configs.GameState = Configs.GameState.IDLE

@onready var player_: Node2D = $Player
@onready var spawn_enemy_timer_: Timer = $SpawnEnemyTimer
@onready var score_timer_: Timer = $ScoreTimer
@onready var ui_control_: Control = $UIControl

func _ready():
    player_.connect("player_died", Callable(self, "_on_player_died"))
    ui_control_.connect("game_started", Callable(self, "_on_game_started"))
    update_game_state(game_state_)

func _on_spawn_enemy_timer_timeout() -> void:
    add_child(ENEMY_SCENE.instantiate())

func _on_score_timer_timeout() -> void:
    score_ += 1
    ui_control_.update_score(score_)

func _on_player_died() -> void:
    update_game_state(Configs.GameState.GAME_OVER)

func _on_game_started() -> void:
    update_game_state(Configs.GameState.PLAYING)

func _reload_current_scene() -> void:
    get_tree().reload_current_scene()

func update_game_state(game_state: Configs.GameState) -> void:
    if game_state_ == game_state:
        return
    game_state_ = game_state
    match game_state:
        Configs.GameState.IDLE:
            spawn_enemy_timer_.stop()
            score_timer_.stop()
            score_ = 0
        Configs.GameState.PLAYING:
            spawn_enemy_timer_.start()
            score_timer_.start()
        Configs.GameState.GAME_OVER:
            spawn_enemy_timer_.stop()
            score_timer_.stop()
            call_deferred("_reload_current_scene")
    ui_control_.update_game_state(game_state)
