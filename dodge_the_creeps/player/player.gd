extends Node2D

signal player_died

#region Player constants
const PLAYER_ACTION_LEFT: String = "player_action_left"
const PLAYER_ACTION_RIGHT: String = "player_action_right"
const PLAYER_ACTION_UP: String = "player_action_up"
const PLAYER_ACTION_DOWN: String = "player_action_down"
const PLAYER_ANIMATION_RIGHT_OR_LEFT: String = "right_or_left"
const PLAYER_ANIMATION_UP_OR_DOWN: String = "up_or_down"
#endregion

const PLAYER_MOVE_SPEED: int = 200

@onready var animated_sprite_: AnimatedSprite2D = $Area2D/AnimatedSprite2D

func _physics_process(delta: float) -> void:
    var direction: Vector2 = Vector2(
        Input.get_action_strength(PLAYER_ACTION_RIGHT) - Input.get_action_strength(PLAYER_ACTION_LEFT),
        Input.get_action_strength(PLAYER_ACTION_DOWN) - Input.get_action_strength(PLAYER_ACTION_UP)
    )
    if direction.length() > 0:
        direction = direction.normalized()
        var new_position: Vector2 = self.position + direction * PLAYER_MOVE_SPEED * delta
        self.position = clamp_to_screen(new_position)
    update_animation(direction)

func _on_area_2d_area_entered(area: Area2D) -> void:
    if not area.get_parent().is_in_group("enemies"):
        return
    player_died.emit()

func clamp_to_screen(pos: Vector2) -> Vector2:
    var viewport_rect = get_viewport().get_visible_rect()
    return Vector2(
        clamp(pos.x, viewport_rect.position.x, viewport_rect.position.x + viewport_rect.size.x),
        clamp(pos.y, viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)
    )

func update_animation(direction: Vector2) -> void:
    if direction.length() <= 0:
        animated_sprite_.stop()
        return
    var flip_h: bool = false
    var flip_v: bool = false
    var dir_animation: String = ""
    if direction.x > 0 or direction.x < 0:
        dir_animation = PLAYER_ANIMATION_RIGHT_OR_LEFT
        flip_h = direction.x < 0
    elif direction.y > 0 or direction.y < 0:
        dir_animation = PLAYER_ANIMATION_UP_OR_DOWN
        flip_v = direction.y > 0
    animated_sprite_.animation = dir_animation
    animated_sprite_.flip_h = flip_h
    animated_sprite_.flip_v = flip_v
    animated_sprite_.play()
