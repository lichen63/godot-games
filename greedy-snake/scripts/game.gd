extends Node

enum MapCellState {IDLE, WALL, SNAKE_HEAD, SNAKE_BODY, FOOD}
enum SnakeMoveDirection {UP, DOWN, LEFT, RIGHT}

@warning_ignore("integer_division")
const SNAKE_HEAD_INIT_COORD_X: int = Configs.MAP_CELL_SIZE_X / 2
@warning_ignore("integer_division")
const SNAKE_HEAD_INIT_COORD_Y: int = Configs.MAP_CELL_SIZE_Y / 2
const SNAKE_BODY_INIT_LENGTH: int = 3
const SNAKE_DEFAULT_MOVE_DIR: SnakeMoveDirection = SnakeMoveDirection.RIGHT

@export var snake_head_scene_: PackedScene = null
@export var snake_body_scene_: PackedScene = null
@export var food_scene_: PackedScene = null
var cell_data_: Array = []
var snake_head_: Node2D = null
var snake_bodies_: Array[Node2D] = []
var snake_move_timer_ :Timer = null
var snake_move_time_interval_ = 1.0
var snake_cur_move_dir_: SnakeMoveDirection = SNAKE_DEFAULT_MOVE_DIR
var snake_next_move_dir_: SnakeMoveDirection = SNAKE_DEFAULT_MOVE_DIR
var food_: Node2D = null

# Called when the node enters the scene tree for the first time
func _ready() -> void:
  # Initialize the cell state
  for x in range(0, Configs.MAP_CELL_SIZE_X):
    var column_data: Array = []
    column_data.push_back(MapCellState.WALL)
    for y in range(1, Configs.MAP_CELL_SIZE_Y - 1):
      if x == 0 or x == Configs.MAP_CELL_SIZE_X - 1:
        column_data.push_back(MapCellState.WALL)
      else:
        column_data.push_back(MapCellState.IDLE)
    column_data.push_back(MapCellState.WALL)
    cell_data_.push_back(column_data)
  # Initialize the snake
  snake_head_ = snake_head_scene_.instantiate()
  snake_head_.position = calc_pos_from_coords(Vector2i(SNAKE_HEAD_INIT_COORD_X, SNAKE_HEAD_INIT_COORD_Y))
  add_child(snake_head_)
  for i in SNAKE_BODY_INIT_LENGTH:
    add_body_to_tail(SNAKE_HEAD_INIT_COORD_X - i - 1, SNAKE_HEAD_INIT_COORD_Y)
  # Initialize the timer for moving snake
  snake_move_timer_ = Timer.new()
  snake_move_timer_.wait_time = snake_move_time_interval_
  snake_move_timer_.one_shot = false
  snake_move_timer_.autostart = true
  add_child(snake_move_timer_)
  snake_move_timer_.connect("timeout", Callable(self, "_on_snake_move_timer_timeout"))
  # Initialize the food
  # Get all the idle map cell
  var idle_cells: Array[Vector2i] = []
  for x in range(1, Configs.MAP_CELL_SIZE_X - 1):
    for y in range(1, Configs.MAP_CELL_SIZE_Y - 1):
      if cell_data_[x][y] == MapCellState.IDLE:
        idle_cells.push_back(Vector2i(x, y))
  if idle_cells.size() == 0:
    return  # TODO: End game with success
  var rand_index: int = randi_range(0, idle_cells.size() - 1)
  var food_coords: Vector2i = idle_cells[rand_index]
  food_ = food_scene_.instantiate()
  food_.position = calc_pos_from_coords(food_coords)
  cell_data_[food_coords.x][food_coords.y] = MapCellState.FOOD
  add_child(food_)

# Called during the physics processing step of the main loop
func _physics_process(_delta:float) -> void:
  if Input.get_action_strength(Configs.ACTION_SNAKE_LEFT):
    snake_next_move_dir_ = SnakeMoveDirection.LEFT
  elif Input.get_action_strength(Configs.ACTION_SNAKE_RIGHT):
    snake_next_move_dir_ = SnakeMoveDirection.RIGHT
  elif Input.get_action_strength(Configs.ACTION_SNAKE_UP):
    snake_next_move_dir_ = SnakeMoveDirection.UP
  elif Input.get_action_strength(Configs.ACTION_SNAKE_DOWN):
    snake_next_move_dir_ = SnakeMoveDirection.DOWN

# Snake move timer timeout event
func _on_snake_move_timer_timeout() -> void:
  # If next direction is opposite to current, ignore it
  if not check_next_move_dir_valid():
    # Restore the next move direction
    snake_next_move_dir_ = snake_cur_move_dir_
  else:
    snake_cur_move_dir_ = snake_next_move_dir_
  var cur_coords: Vector2i = calc_coords_from_pos(snake_head_.position)
  var next_coords: Vector2i = calc_next_coords(cur_coords)
  if not check_coords_valid(next_coords):
    Logger.info("Game Over!")
    return  # TODO: End game with failure
  if check_coords_has_food(next_coords):
    pass  # TODO: Consume the food, increase the body length and refresh food position
  # Move the snake head postion
  snake_head_.position = calc_pos_from_coords(next_coords)
  cell_data_[next_coords.x][next_coords.y] = MapCellState.SNAKE_HEAD
  # Move the tail snake body node to right after head node
  var snake_tail: Node2D = snake_bodies_.pop_back()
  var tail_prev_coords = calc_coords_from_pos(snake_tail.position)
  snake_tail.position = calc_pos_from_coords(cur_coords)
  snake_bodies_.push_front(snake_tail)
  cell_data_[tail_prev_coords.x][tail_prev_coords.y] = MapCellState.IDLE
  cell_data_[cur_coords.x][cur_coords.y] = MapCellState.SNAKE_BODY

# Calculate the position from coordinate
func calc_pos_from_coords(coords: Vector2i) -> Vector2:
  var pos_x: float = Configs.MAP_CELL_WIDTH * coords.x
  var pos_y: float = Configs.MAP_CELL_WIDTH * coords.y
  return Vector2(pos_x, pos_y)

# Calculate the coordinate from position
func calc_coords_from_pos(pos: Vector2) -> Vector2i:
  var coord_x: int = int(pos.x / Configs.WALL_WIDTH)
  var coord_y: int = int(pos.y / Configs.WALL_WIDTH)
  return Vector2i(coord_x, coord_y)

# Calculate the next coordinate by current coordinate and direction
func calc_next_coords(coords: Vector2i) -> Vector2i:
  match (snake_cur_move_dir_):
    SnakeMoveDirection.UP:
      coords.y -= 1
    SnakeMoveDirection.DOWN:
      coords.y += 1
    SnakeMoveDirection.LEFT:
      coords.x -= 1
    SnakeMoveDirection.RIGHT:
      coords.x += 1
    _:
      pass
  return coords

# Check if the next move direction is valid or not
func check_next_move_dir_valid() -> bool:
  if snake_cur_move_dir_ == SnakeMoveDirection.LEFT && snake_next_move_dir_ == SnakeMoveDirection.RIGHT:
    return false
  if snake_cur_move_dir_ == SnakeMoveDirection.RIGHT && snake_next_move_dir_ == SnakeMoveDirection.LEFT:
    return false
  if snake_cur_move_dir_ == SnakeMoveDirection.UP && snake_next_move_dir_ == SnakeMoveDirection.DOWN:
    return false
  if snake_cur_move_dir_ == SnakeMoveDirection.DOWN && snake_next_move_dir_ == SnakeMoveDirection.UP:
    return false
  return true

# Check if the coordinate is valid or not
func check_coords_valid(coords: Vector2i) -> bool:
  if coords.x < 0 || coords.x >= Configs.MAP_CELL_SIZE_X:
    return false
  if coords.y < 0 || coords.y >= Configs.MAP_CELL_SIZE_Y:
    return false
  if cell_data_[coords.x][coords.y] == MapCellState.WALL:
    return false
  if cell_data_[coords.x][coords.y] == MapCellState.SNAKE_BODY:
    return false
  if cell_data_[coords.x][coords.y] == MapCellState.SNAKE_HEAD:
    return false
  return true

# Check if the coordinate has food on it
func check_coords_has_food(coords: Vector2i) -> bool:
  return cell_data_[coords.x][coords.y] == MapCellState.FOOD

# Append a new snake body to the tail
func add_body_to_tail(coords_x: int, coords_y: int) -> void:
  var snake_body: Node2D = snake_body_scene_.instantiate()
  snake_body.position = calc_pos_from_coords(Vector2i(coords_x, coords_y))
  snake_bodies_.push_back(snake_body)
  add_child(snake_body)

func get_snake_length() -> int:
  return snake_bodies_.size()

# Get the tail node of snake
func get_tail_node() -> Node2D:
  if get_snake_length() == 0:
    return snake_head_
  return snake_bodies_.back()
