extends Control

const SCORE_PREFIX: String = "Score: "

@onready var label_: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func update_score(score: int) -> void:
    label_.text = SCORE_PREFIX + str(score)
