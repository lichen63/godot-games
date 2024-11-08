extends Node

#region export vars
@export var snake_move_timer_: Timer = null
@export var snake_nodes_: Node2D = null
@export var result_panel_: Node = null
@export var snake_food_: Node2D = null
#endregion

#region const vars
const SNAKE_DEFAULT_MOVE_DIR = Configs.SnakeMoveDirection.RIGHT
#endregion

#region private vars
var snake_cur_move_dir_: Configs.SnakeMoveDirection = SNAKE_DEFAULT_MOVE_DIR
var snake_next_move_dir_: Configs.SnakeMoveDirection = SNAKE_DEFAULT_MOVE_DIR
var game_state_: Configs.GameState = Configs.GameState.IDLE
#endregion

#region public methods
# Update the game state
func update_game_state(state: Configs.GameState) -> void:
    if self.game_state_ == state and state != Configs.GameState.IDLE:
      return
  
    self.result_panel_.exit_state(self.game_state_)
    self.snake_move_timer_.exit_state(self.game_state_)
    self.snake_nodes_.exit_state(self.game_state_)
    self.snake_food_.exit_state(self.game_state_)
    self.exit_state(self.game_state_)

    self.game_state_ = state

    self.enter_state(state)
    self.snake_food_.enter_state(state)
    self.snake_nodes_.enter_state(state)
    self.snake_move_timer_.enter_state(state)
    self.result_panel_.enter_state(state)

func exit_state(state: Configs.GameState) -> void:
    match state:
        Configs.GameState.IDLE:
            pass
        Configs.GameState.PLAYING:
            pass
        Configs.GameState.SUCCESS:
            pass
        Configs.GameState.FAILURE:
            pass
        Configs.GameState.PAUSED:
            pass
        _:
            pass

func enter_state(state: Configs.GameState) -> void:
  match state:
        Configs.GameState.IDLE:
            self._reset_cell_and_dir_state()
        Configs.GameState.PLAYING:
            pass
        Configs.GameState.SUCCESS:
            self._reset_cell_and_dir_state()
        Configs.GameState.FAILURE:
            self._reset_cell_and_dir_state()
        Configs.GameState.PAUSED:
            pass
        _:
            pass

#endregion

#region private methods
# Calculate the next coordinate by current coordinate and direction
func _calc_next_coord(coord: Vector2i) -> Vector2i:
    var next_coord: Vector2i = coord;
    match (self.snake_cur_move_dir_):
        Configs.SnakeMoveDirection.UP:
            next_coord.y -= 1
        Configs.SnakeMoveDirection.DOWN:
            next_coord.y += 1
        Configs.SnakeMoveDirection.LEFT:
            next_coord.x -= 1
        Configs.SnakeMoveDirection.RIGHT:
            next_coord.x += 1
        _:
            pass
    return next_coord

# Check if the next move direction is valid or not
func _check_next_move_dir_valid() -> bool:
    if self.snake_cur_move_dir_ == Configs.SnakeMoveDirection.LEFT && self.snake_next_move_dir_ == Configs.SnakeMoveDirection.RIGHT:
        return false
    if self.snake_cur_move_dir_ == Configs.SnakeMoveDirection.RIGHT && self.snake_next_move_dir_ == Configs.SnakeMoveDirection.LEFT:
        return false
    if self.snake_cur_move_dir_ == Configs.SnakeMoveDirection.UP && self.snake_next_move_dir_ == Configs.SnakeMoveDirection.DOWN:
        return false
    if self.snake_cur_move_dir_ == Configs.SnakeMoveDirection.DOWN && self.snake_next_move_dir_ == Configs.SnakeMoveDirection.UP:
        return false
    return true

func _reset_cell_and_dir_state() -> void:
    MapController.reset_map_cell_state()
    self.snake_cur_move_dir_ = SNAKE_DEFAULT_MOVE_DIR
    self.snake_next_move_dir_ = SNAKE_DEFAULT_MOVE_DIR
#endregion

#region private signals
# Called when the node enters the scene tree for the first time
func _ready() -> void:
    self.update_game_state(Configs.GameState.IDLE)

# Called during the physics processing step of the main loop
func _physics_process(_delta: float) -> void:
  # Get the input direction from player
    if Input.get_action_strength(Configs.ACTION_SNAKE_LEFT):
        self.snake_next_move_dir_ = Configs.SnakeMoveDirection.LEFT
    elif Input.get_action_strength(Configs.ACTION_SNAKE_RIGHT):
        self.snake_next_move_dir_ = Configs.SnakeMoveDirection.RIGHT
    elif Input.get_action_strength(Configs.ACTION_SNAKE_UP):
        self.snake_next_move_dir_ = Configs.SnakeMoveDirection.UP
    elif Input.get_action_strength(Configs.ACTION_SNAKE_DOWN):
        self.snake_next_move_dir_ = Configs.SnakeMoveDirection.DOWN
    elif Input.get_action_strength(Configs.ACTION_GAME_PAUSE):
        self.update_game_state(Configs.GameState.PAUSED)

# Snake move timer timeout event
func _on_snake_move_timer_timeout() -> void:
    if self.game_state_ != Configs.GameState.PLAYING:
        return
    if not _check_next_move_dir_valid():
        self.snake_next_move_dir_ = self.snake_cur_move_dir_
    else:
        self.snake_cur_move_dir_ = self.snake_next_move_dir_
    var snake_head_pos: Vector2 = self.snake_nodes_.get_head_node_pos()
    var cur_coord: Vector2i = MapController.calc_coord_from_pos(snake_head_pos)
    var next_coord: Vector2i = self._calc_next_coord(cur_coord)
    if not MapController.check_coord_is_available(next_coord):
        self.update_game_state(Configs.GameState.FAILURE)
        return
    var has_food: bool = MapController.check_coord_has_food(next_coord)
    if has_food:
        self.snake_food_.refresh_position()
    self.snake_nodes_.move_snake_node(next_coord, has_food)

#endregion
