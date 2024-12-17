extends Control

const LINES: Array = [
    "You defeated the boss",
    "Peace comes again",
    "But is it all worth?"
]

var cur_line: int = -1
var tween: Tween = null

@onready var label: Label = $Label

func _ready() -> void:
    self.show_line(0)

func _input(event: InputEvent) -> void:
    if self.tween.is_running():
        return
    if (event is InputEventKey or
        event is InputEventMouseButton or
        event is InputEventJoypadButton):
        if event.is_pressed() and not event.is_echo():
            if self.cur_line + 1 < LINES.size():
                self.show_line(self.cur_line + 1)
            else:
                Game.back_to_title()

func show_line(line: int) -> void:
    self.cur_line = line
    self.tween = create_tween()
    self.tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
    if line > 0:
        self.tween.tween_property(self.label, "modulate:a", 0, 1)
    else:
        self.label.modulate.a = 0
    self.tween.tween_callback(self.label.set_text.bind(LINES[line]))
    self.tween.tween_property(self.label, "modulate:a", 1, 1)
