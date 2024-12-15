extends Node2D

@onready var tile_map_layer_1: TileMapLayer = $TileMapLayer1
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
    var used: Rect2i = tile_map_layer_1.get_used_rect().grow(-1)
    var tile_size: Vector2i = tile_map_layer_1.tile_set.tile_size
    
    camera_2d.limit_top = used.position.y * tile_size.y
    camera_2d.limit_right = used.end.x * tile_size.x
    camera_2d.limit_bottom = used.end.y * tile_size.y
    camera_2d.limit_left = used.position.x * tile_size.x
    camera_2d.reset_smoothing()

func update_player(pos: Vector2, dir: Player.Direction) -> void:
    self.player.global_position = pos
    self.player.fall_from_y = pos.y
    self.player.direction = dir
    self.camera_2d.reset_smoothing()
    self.camera_2d.force_update_scroll()

func to_dict() -> Dictionary:
    var enemies_alive: Array = []
    for node in self.get_tree().get_nodes_in_group("enemies"):
        enemies_alive.append(get_path_to(node))
    return {
        enemies_alive = enemies_alive,
    }

func from_dict(dict: Dictionary) -> void:
    for node in self.get_tree().get_nodes_in_group("enemies"):
        var path: String = get_path_to(node)
        if not path in dict.enemies_alive:
            node.queue_free()
