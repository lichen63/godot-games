extends Control

@onready var new_game_button: Button = $NewGame

func _ready() -> void:
  TranslationServer.set_locale("zh")
  self.new_game_button.grab_focus()

func _on_start_pressed() -> void:
  self.get_tree().change_scene_to_file("res://scenes/home/home.tscn")

func _on_language_item_selected(index: int) -> void:
  match(index):
    0:
      TranslationServer.set_locale("zh")
    1:
      TranslationServer.set_locale("en")
    _:
      print("unsupported language: %d" % index)
