extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    self.hide()
    self.set_process_input(false)

func _input(event: InputEvent) -> void:
    self.get_window().set_input_as_handled()
    if self.animation_player.is_playing():
        return
    if (event is InputEventKey or
        event is InputEventMouseButton or
        event is InputEventJoypadButton):
        if event.is_pressed() and not event.is_echo():
            if Game.has_save():
                Game.load_game()
            else:
                Game.back_to_title()

func show_game_over() -> void:
    self.show()
    self.set_process_input(true)
    self.animation_player.play("enter")
