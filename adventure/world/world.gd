extends Node2D

@onready var tile_map_layer_1: TileMapLayer = $TileMapLayer1
@onready var camera_2d: Camera2D = $Player/Camera2D

func _ready() -> void:
    var used: Rect2i = tile_map_layer_1.get_used_rect().grow(-1)
    var tile_size: Vector2i = tile_map_layer_1.tile_set.tile_size
    
    camera_2d.limit_top = used.position.y * tile_size.y
    camera_2d.limit_right = used.end.x * tile_size.x
    camera_2d.limit_bottom = used.end.y * tile_size.y
    camera_2d.limit_left = used.position.x * tile_size.x
    camera_2d.reset_smoothing()
