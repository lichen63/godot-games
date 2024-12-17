extends Node

@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer

func play_sfx(name: String) -> void:
    var player: AudioStreamPlayer = self.sfx.get_node(name)
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

    for child in node.get_children():
        setup_ui_sounds(child)
