extends Node2D

const ENEMY_MOVE_SPEED: int = 150
var move_direction_: Vector2 = Vector2.ZERO

func _ready() -> void:
    randomize_position_and_direction()

func _physics_process(delta: float) -> void:
    self.position += move_direction_ * ENEMY_MOVE_SPEED * delta

func randomize_position_and_direction() -> void:
    var viewport_rect: Rect2 = get_viewport().get_visible_rect()
    var screen_width: float = viewport_rect.size.x
    var screen_height: float = viewport_rect.size.y
    var random_edge: int = randi() % 4
    match random_edge:
        0:  # up
            self.position = Vector2(randf() * screen_width, 0)
            move_direction_ = Vector2(randf() * 2 - 1, 1).normalized()
        1:  # down
            self.position = Vector2(randf() * screen_width, screen_height)
            move_direction_ = Vector2(randf() * 2 - 1, -1).normalized()
        2:  # left
            self.position = Vector2(0, randf() * screen_height)
            move_direction_ = Vector2(1, randf() * 2 - 1).normalized()
        3:  # down
            self.position = Vector2(screen_width, randf() * screen_height)
            move_direction_ = Vector2(-1, randf() * 2 - 1).normalized()
    move_direction_.normalized()
