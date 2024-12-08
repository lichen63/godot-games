extends Node2D

@onready var tile_map_layer_ : TileMapLayer = $TileMapLayer
@onready var camera_2d_: Camera2D = $Player/Camera2D

func _ready() -> void:
    var used: Rect2i = tile_map_layer_.get_used_rect()
    var tile_size: Vector2i = tile_map_layer_.tile_set.tile_size
    
    camera_2d_.limit_top = used.position.y * tile_size.y
    camera_2d_.limit_right = used.end.x * tile_size.x
    camera_2d_.limit_bottom = used.end.y * tile_size.y
    camera_2d_.limit_left = used.position.x * tile_size.x
    camera_2d_.reset_smoothing()
