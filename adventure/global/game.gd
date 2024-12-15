extends Node

# scene_name => {
#     enemies_alive => [enemy_path],
# }
var world_states: Dictionary = {}

@onready var player_stats: Stats = $PlayerStats
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
    self.color_rect.color.a = 0

func change_scene(path: String, entry_point: String) -> void:
    var tree: SceneTree = self.get_tree()
    tree.paused = true
    var tween: Tween = self.create_tween()
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(self.color_rect, "color:a", 1, 0.2)
    await tween.finished
    var old_name: String = tree.current_scene.scene_file_path.get_file().get_basename()
    self.world_states[old_name] = tree.current_scene.to_dict()
    tree.change_scene_to_file(path)
    await tree.tree_changed
    var new_name: String = tree.current_scene.scene_file_path.get_file().get_basename()
    if new_name in self.world_states:
        tree.current_scene.from_dict(self.world_states[new_name])
    for node in tree.get_nodes_in_group("entry_points"):
        if node.name == entry_point:
            tree.current_scene.update_player(node.global_position, node.direction)
            break
    tree.paused = false
    tween = self.create_tween()
    tween.tween_property(self.color_rect, "color:a", 0, 0.2)
