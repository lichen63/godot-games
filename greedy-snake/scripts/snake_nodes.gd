extends Node2D

#region export vars
@export var snake_head_scene_: PackedScene = null
@export var snake_body_scene_: PackedScene = null
#endregion

#region const vars
@warning_ignore("integer_division")
const SNAKE_HEAD_INIT_COORD_X: int = Configs.MAP_CELL_SIZE_X / 2
@warning_ignore("integer_division")
const SNAKE_HEAD_INIT_COORD_Y: int = Configs.MAP_CELL_SIZE_Y / 2
#endregion

#region private vars
var snake_head_: Node2D = null
var snake_bodies_: Array[Node2D] = []
#endregion

#region public methods
func move_snake_node(next_coord: Vector2i, new_body: bool) -> void:
    var cur_coord: Vector2i = MapController.calc_coord_from_pos(self.snake_head_.position)
    self._move_head_node(cur_coord, next_coord)
    if new_body:
        self._add_new_body(cur_coord)
    else:
        self._move_body_node(cur_coord)
    if self.snake_bodies_.size() >= Configs.SNAKE_BODY_MAX_LENGTH:
        self.get_parent().update_game_state(Configs.GameState.SUCCESS)

func get_head_node_pos() -> Vector2:
    return self.snake_head_.position

func exit_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            pass
        Configs.GameState.PLAYING:
            pass
        Configs.GameState.SUCCESS:
            self._reset_snake_node()
        Configs.GameState.FAILURE:
            self._reset_snake_node()
        Configs.GameState.PAUSED:
            pass
        _:
            pass

func enter_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            self._reset_snake_node()
            self.hide()
        Configs.GameState.PLAYING:
            self.show()
        Configs.GameState.SUCCESS:
            self.hide()
        Configs.GameState.FAILURE:
            self.hide()
        Configs.GameState.PAUSED:
            self.hide()
        _:
            pass

#endregion

#region private methods
func _move_head_node(cur_coord: Vector2i, next_coord: Vector2i) -> void:
    self.snake_head_.position = MapController.calc_pos_from_coord(next_coord)
    MapController.update_coord_state(cur_coord, MapController.MapCellState.BLANK)
    MapController.update_coord_state(next_coord, MapController.MapCellState.SNAKE)

func _add_new_body(coord: Vector2i) -> void:
    var snake_body: Node2D = snake_body_scene_.instantiate()
    snake_body.position = MapController.calc_pos_from_coord(coord)
    self.add_child(snake_body)
    self.snake_bodies_.push_front(snake_body)
    MapController.update_coord_state(coord, MapController.MapCellState.SNAKE)

func _move_body_node(next_coord: Vector2i) -> void:
    var tail_node: Node2D = self.snake_bodies_.pop_back()
    var cur_coord = MapController.calc_coord_from_pos(tail_node.position)
    tail_node.position = MapController.calc_pos_from_coord(next_coord)
    self.snake_bodies_.push_front(tail_node)
    MapController.update_coord_state(cur_coord, MapController.MapCellState.BLANK)
    MapController.update_coord_state(next_coord, MapController.MapCellState.SNAKE)

func _reset_snake_node() -> void:
    if not is_instance_valid(self.snake_head_):
        self.snake_head_ = self.snake_head_scene_.instantiate()
        self.add_child(self.snake_head_)
    for body in self.snake_bodies_:
        self.remove_child(body)
    self.snake_bodies_.clear()
    var init_coord: Vector2i = Vector2i(SNAKE_HEAD_INIT_COORD_X, SNAKE_HEAD_INIT_COORD_Y)
    self._move_head_node(init_coord, init_coord)
    for i in range(Configs.SNAKE_BODY_INIT_LENGTH - 1, -1, -1):
        self._add_new_body(Vector2i(SNAKE_HEAD_INIT_COORD_X - i - 1, SNAKE_HEAD_INIT_COORD_Y))

#endregion
