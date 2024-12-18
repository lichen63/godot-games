extends Control

@onready var resume: Button = $V/Actions/H/Resume

func _ready() -> void:
    self.hide()
    SoundManager.setup_ui_sounds(self)
    self.visibility_changed.connect(func():
        self.get_tree().paused = self.visible
    )

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause"):
        self.hide()
        self.get_window().set_input_as_handled()

func show_pause() -> void:
    self.show()
    self.resume.grab_focus()

func _on_resume_pressed() -> void:
    self.hide()

func _on_quit_pressed() -> void:
    Game.back_to_title()
