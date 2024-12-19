extends Node

enum Bus { MASTER, SFX, BGM }

@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer

func play_sfx(sfx_name: String) -> void:
    var player: AudioStreamPlayer = self.sfx.get_node(sfx_name)
    if not player:
        return
    player.play()

func play_bgm(stream: AudioStream) -> void:
    if self.bgm_player.stream == stream and self.bgm_player.playing:
        return
    self.bgm_player.stream = stream
    self.bgm_player.play()

func setup_ui_sounds(node: Node) -> void:
    var button := node as Button
    if button:
        button.pressed.connect(self.play_sfx.bind("UIPress"))
        button.focus_entered.connect(self.play_sfx.bind("UIFocus"))
        button.mouse_entered.connect(button.grab_focus)
    var slider := node as Slider
    if slider:
        slider.value_changed.connect(self.play_sfx.bind("UIPress").unbind(1))
        slider.focus_entered.connect(self.play_sfx.bind("UIFocus"))
        slider.mouse_entered.connect(slider.grab_focus)

    for child in node.get_children():
        setup_ui_sounds(child)

func get_volume(bus_index: int) -> float:
    var db: float = AudioServer.get_bus_volume_db(bus_index)
    return db_to_linear(db)

func set_volume(bus_index: int, v: float) -> void:
    var db: float = linear_to_db(v)
    AudioServer.set_bus_volume_db(bus_index, db)
