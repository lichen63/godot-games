extends Node

const ENEMY_SCENE: PackedScene = preload("res://enemy/enemy.tscn")
const AUDIO_BACKGROUND: AudioStream = preload("res://assets/audio/background.ogg")
const AUDIO_GAMEOVER: AudioStream = preload("res://assets/audio/gameover.wav")
const MAX_SCORE_KEY: String = "max_score"

var score_: int = 0
var max_score_: int = 0
var game_state_: Configs.GameState = Configs.GameState.IDLE

@onready var player_: Node2D = $Player
@onready var spawn_enemy_timer_: Timer = $SpawnEnemyTimer
@onready var score_timer_: Timer = $ScoreTimer
@onready var canvas_layer_: CanvasLayer = $CanvasLayer
@onready var audio_stream_player_: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var enemy_spawn_location_: PathFollow2D = $EnemyPath/EnemySpawnLocation

func _ready():
    player_.connect("player_died", Callable(self, "_on_player_died"))
    canvas_layer_.connect("game_started", Callable(self, "_on_game_started"))
    update_game_state(game_state_)
    var max_score_from_local_data = LocalData.read_from_local_data(MAX_SCORE_KEY)
    max_score_ = max_score_from_local_data if max_score_from_local_data != null else 0

func _on_spawn_enemy_timer_timeout() -> void:
    var enemy_node: RigidBody2D = ENEMY_SCENE.instantiate()
    # Choose a random location on Path2D.
    enemy_spawn_location_.progress_ratio = randf()
    # Set the direction perpendicular to the path direction.
    var enemy_direction = enemy_spawn_location_.rotation + PI / 2
    # Set the position to a random location.
    enemy_node.position = enemy_spawn_location_.position
    # Add some randomness to the direction.
    enemy_direction += randf_range(-PI / 4, PI / 4)
    enemy_node.rotation = enemy_direction
    # Choose the velocity for the enemy.
    var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
    enemy_node.linear_velocity = velocity.rotated(enemy_direction)
    add_child(enemy_node)

func _on_score_timer_timeout() -> void:
    score_ += 1
    canvas_layer_.update_score(score_)

func _on_player_died() -> void:
    update_game_state(Configs.GameState.GAME_OVER)

func _on_game_started() -> void:
    update_game_state(Configs.GameState.PLAYING)

func _reload_current_scene() -> void:
    get_tree().reload_current_scene()

func update_game_state(game_state: Configs.GameState) -> void:
    game_state_ = game_state
    match game_state:
        Configs.GameState.IDLE:
            score_ = 0
            player_.visible = true
            spawn_enemy_timer_.stop()
            score_timer_.stop()
        Configs.GameState.PLAYING:
            player_.visible = true
            spawn_enemy_timer_.start()
            score_timer_.start()
        Configs.GameState.GAME_OVER:
            var is_new_max_score: bool = score_ > max_score_
            max_score_ = max(score_, max_score_)
            canvas_layer_.update_max_score(max_score_, is_new_max_score)
            LocalData.write_to_local_data(MAX_SCORE_KEY, max_score_)
            score_ = 0
            player_.visible = false
            spawn_enemy_timer_.stop()
            score_timer_.stop()
            get_tree().get_nodes_in_group("enemies").map(func(enemy): enemy.queue_free())
            player_.reset_node()
            canvas_layer_.update_score(score_)
    canvas_layer_.update_game_state(game_state)
    update_audio_stream()

func update_audio_stream() -> void:
    var cur_stream: AudioStream = audio_stream_player_.stream
    var new_stream: AudioStream = AUDIO_GAMEOVER if game_state_ == Configs.GameState.GAME_OVER else AUDIO_BACKGROUND
    if cur_stream == new_stream:
        return
    audio_stream_player_.stream = new_stream
    audio_stream_player_.play()
