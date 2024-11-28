extends Node2D

enum EdgeDir {
    TOP,
    BOTTOM,
    LEFT,
    RIGHT
}

const SPEED: int = 10

@onready var screen_size_: Vector2 = get_viewport().get_visible_rect().size

func _ready():
    randomize()
    var start_edge: EdgeDir = EdgeDir.values()[randi() % EdgeDir.size()]
    var start_pos: Vector2 = get_random_pos_on_edge(start_edge)
    var end_pos: Vector2 = get_random_pos_on_edge(get_opposite_edge(start_edge))
    self.position = start_pos
    var curve_node: Curve2D = $Path2D.curve
    curve_node.clear_points()
    curve_node.add_point(Vector2.ZERO)
    curve_node.add_point(end_pos - start_pos)

    var follow_node: PathFollow2D = $Path2D/PathFollow2D
    follow_node.loop = false

    # 打印日志
    print("start_pos: ", start_pos)
    print("end_pos: ", end_pos)
    for i in range(curve_node.get_point_count()):
        print("curve_node point ", i, ": ", curve_node.get_point_position(i))

func _physics_process(delta: float) -> void:
    var follow_node = $Path2D/PathFollow2D
    follow_node.progress += SPEED * delta
    self.position = follow_node.global_position
    if not $VisibleOnScreenNotifier2D.is_on_screen():
        queue_free()

func get_random_pos_on_edge(edge_dir: EdgeDir) -> Vector2:
    match edge_dir:
        EdgeDir.TOP:
            return Vector2(randf() * screen_size_.x, 0)
        EdgeDir.BOTTOM:
            return Vector2(randf() * screen_size_.x, screen_size_.y)
        EdgeDir.LEFT:
            return Vector2(0, randf() * screen_size_.y)
        EdgeDir.RIGHT:
            return Vector2(screen_size_.x, randf() * screen_size_.y)
    return Vector2.ZERO

func get_opposite_edge(edge_dir: EdgeDir) -> EdgeDir:
    match edge_dir:
        EdgeDir.TOP:
            return EdgeDir.BOTTOM
        EdgeDir.BOTTOM:
            return EdgeDir.TOP
        EdgeDir.LEFT:
            return EdgeDir.RIGHT
        EdgeDir.RIGHT:
            return EdgeDir.LEFT
    return edge_dir
