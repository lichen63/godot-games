extends Control

@onready var v: VBoxContainer = $V
@onready var new_game: Button = $V/NewGame
@onready var load_game: Button = $V/LoadGame

func _ready() -> void:
    self.load_game.disabled = not Game.has_save()
    self.new_game.grab_focus()
    SoundManager.setup_ui_sounds(self)
    SoundManager.play_bgm(preload("res://assets/sounds/bgm/titles-loop.mp3"))

func _on_new_game_pressed() -> void:
    Game.new_game()

func _on_load_game_pressed() -> void:
    Game.load_game()

func _on_exit_game_pressed() -> void:
    self.get_tree().quit()
