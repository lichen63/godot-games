extends AnimatedSprite2D

const STICK_DEADZONE: float = 0.3
const MOUSE_DEADZONE: float = 16.0

func _ready() -> void:
    if Input.get_connected_joypads():
        self.show_joypad_icon(0)
    else:
        self.play("keyboard")

func _input(event: InputEvent) -> void:
    if event is InputEventJoypadButton or (event is InputEventJoypadMotion and abs(event.axis_value) > STICK_DEADZONE):
        self.show_joypad_icon(event.device)
    if event is InputEventKey or event is InputEventMouseButton or (event is InputEventMouseMotion and event.velocity.length() > MOUSE_DEADZONE):
        self.play("keyboard")

func show_joypad_icon(device: int) -> void:
    var joypad_name: String = Input.get_joy_name(device)
    if "Nintendo" in joypad_name:
        self.play("nintendo")
    elif "DualShock" in joypad_name or "PS" in joypad_name:
        self.play("nintendo")   # PlayStation
    else:
        self.play("nintendo")   # Xbox
