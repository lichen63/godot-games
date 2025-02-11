extends CanvasLayer

signal game_started

const SCORE_PREFIX: String = "Score: "

@onready var score_label_: Label = $ScoreLabel
@onready var start_button_: Button = $StartButton
@onready var game_over_label_: Label = $GameOverLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func update_score(score: int) -> void:
    score_label_.text = SCORE_PREFIX + str(score)

func update_game_state(game_state: Configs.GameState) -> void:
    match game_state:
        Configs.GameState.IDLE:
            score_label_.visible = true
            start_button_.visible = true
            game_over_label_.visible = false
        Configs.GameState.PLAYING:
            score_label_.visible = true
            start_button_.visible = false
            game_over_label_.visible = false
        Configs.GameState.GAME_OVER:
            score_label_.visible = true
            start_button_.visible = true
            game_over_label_.visible = true

func _on_start_button_button_down() -> void:
    game_started.emit()

func update_max_score(max_score: int, is_new_max_score: bool) -> void:
    game_over_label_.text = "Game Over!\nMax Score: " + str(max_score)
    if is_new_max_score:
        game_over_label_.text += "\nNew Max Score!"
