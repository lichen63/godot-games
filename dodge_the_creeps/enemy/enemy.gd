extends Node2D

enum EdgeDir {
    TOP,
    BOTTOM,
    LEFT,
    RIGHT
}

const SPEED: int = 6
const ANIMATION_PREFIX: String = "action_"

@onready var screen_size_: Vector2 = get_viewport().get_visible_rect().size
@onready var animated_sprite_: AnimatedSprite2D = $Area2D/AnimatedSprite2D
@onready var path_: Path2D = $Path2D
@onready var path_follow_: PathFollow2D = $Path2D/PathFollow2D
@onready var visible_on_screen_notifier_: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready():
    randomize()
    var start_edge: EdgeDir = EdgeDir.values()[randi() % EdgeDir.size()]
    var start_pos: Vector2 = get_random_pos_on_edge(start_edge)
    var end_pos: Vector2 = get_random_pos_on_edge(get_opposite_edge(start_edge))
    self.position = start_pos
    var curve_node: Curve2D = path_.curve
    curve_node.clear_points()
    curve_node.add_point(Vector2.ZERO)
    curve_node.add_point(end_pos - start_pos)
    animated_sprite_.animation = ANIMATION_PREFIX + str(randi() % 3 + 1)
    animated_sprite_.play()
    var direction: Vector2 = (end_pos - start_pos).normalized()
    animated_sprite_.rotation = direction.angle()

func _physics_process(delta: float) -> void:
    path_follow_.progress += SPEED * delta
    self.position = path_follow_.global_position
    if not visible_on_screen_notifier_.is_on_screen():
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
