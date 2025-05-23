class_name Teleporter
extends Interactable

@export_file("*.tscn") var path: String = ""
@export var entry_point: String = ""

func interact() -> void:
    super.interact()
    Game.change_scene(path, {"entry_point": entry_point})
