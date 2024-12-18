extends Node

const SAVE_PATH: String = "user://data.sav"
const CONFIG_PATH: String = "user://config.ini"

# scene_name => {
#     enemies_alive => [enemy_path],
# }
var world_states: Dictionary = {}

@onready var player_stats: Stats = $PlayerStats
@onready var color_rect: ColorRect = $ColorRect
@onready var default_player_stats: Dictionary = player_stats.to_dict()

func _ready() -> void:
    self.color_rect.color.a = 0
    self.load_config()

func change_scene(path: String, params: Dictionary = {}) -> void:
    var duration: float = params.get("duration", 0.2)
    var tree: SceneTree = self.get_tree()
    tree.paused = true
    var tween: Tween = self.create_tween()
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(self.color_rect, "color:a", 1, duration)
    await tween.finished
    if tree.current_scene is World:
        var old_name: String = tree.current_scene.scene_file_path.get_file().get_basename()
        self.world_states[old_name] = tree.current_scene.to_dict()
    tree.change_scene_to_file(path)
    if "init" in params:
        params.init.call()
    await tree.tree_changed
    if tree.current_scene is World:
        var new_name: String = tree.current_scene.scene_file_path.get_file().get_basename()
        if new_name in self.world_states:
            tree.current_scene.from_dict(self.world_states[new_name])
        if "entry_point" in params:
            for node in tree.get_nodes_in_group("entry_points"):
                if node.name == params.entry_point:
                    tree.current_scene.update_player(node.global_position, node.direction)
                    break
        if "position" in params and "direction" in params:
            tree.current_scene.update_player(params.position, params.direction)
    tree.paused = false
    tween = self.create_tween()
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(self.color_rect, "color:a", 0, duration)

func save_game() -> void:
    var scene: Node = self.get_tree().current_scene
    var scene_name: String = scene.scene_file_path.get_file().get_basename()
    self.world_states[scene_name] = scene.to_dict()
    var data: Dictionary = {
        "world_states": self.world_states,
        "stats": self.player_stats.to_dict(),
        "scene": scene.scene_file_path,
        "player": {
            "direction": scene.player.direction,
            "position": {
                "x": scene.player.global_position.x,
                "y": scene.player.global_position.y,
            },
        }
    }
    var json: String = JSON.stringify(data)
    var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if not file:
        return
    file.store_string(json)

func load_game() -> void:
    var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if not file:
        return
    var json: String = file.get_as_text()
    var data: Dictionary = JSON.parse_string(json) as Dictionary
    await self.change_scene(data.scene, {
        "direction": data.player.direction,
        "position": Vector2(data.player.position.x, data.player.position.y),
        "init": func():
            self.world_states = data.world_states
            self.player_stats.from_dict(data.stats)
    })
    self.get_tree().current_scene.update_player(Vector2(data.player.position.x, data.player.position.y), data.player.direction)
    file.close()

func new_game() -> void:
    self.change_scene("res://world/forest.tscn", {
        "duration": 1.0,
        "init": func():
            self.world_states = {}
            self.player_stats.from_dict(self.default_player_stats)
    })

func back_to_title() -> void:
    self.change_scene("res://ui/title_screen.tscn", {
        "duration": 1.0,
    })

func has_save() -> bool:
    return FileAccess.file_exists(SAVE_PATH)

func save_config() -> void:
    var config: ConfigFile = ConfigFile.new()
    config.set_value("audio", "master", SoundManager.get_volume(SoundManager.Bus.MASTER))
    config.set_value("audio", "sfx", SoundManager.get_volume(SoundManager.Bus.SFX))
    config.set_value("audio", "bgm", SoundManager.get_volume(SoundManager.Bus.BGM))
    config.save(CONFIG_PATH)
    
func load_config() -> void:
    var config: ConfigFile = ConfigFile.new()
    config.load(CONFIG_PATH)
    SoundManager.set_volume(SoundManager.Bus.MASTER, config.get_value("audio", "master", 0.5))
    SoundManager.set_volume(SoundManager.Bus.SFX, config.get_value("audio", "bgm", 1.0))
    SoundManager.set_volume(SoundManager.Bus.SFX, config.get_value("audio", "bgm", 1.0))
