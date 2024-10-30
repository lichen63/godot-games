extends Node2D

enum MoveDirection {UP, DOWN, LEFT, RIGHT}

const MOVE_SPEED:int = 5
const INIT_SNAKE_BODY_LENGTH:int = 3
const BODY_SCENE_PATH:String = "res://scenes/snake_body.tscn"

var body_cur_length_:int = 0
var head_node_:Area2D = null
var head_move_direction_:MoveDirection = MoveDirection.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  head_node_ = get_head_node()
  if not is_instance_valid(head_node_):
    Logger.warning("[snake::_ready] head_node_ is invalid")
    return
    
  for i in INIT_SNAKE_BODY_LENGTH:
    add_body_to_tail()

func _physics_process(_delta:float) -> void:
  if Input.get_action_strength(Configs.ACTION_SNAKE_LEFT):
    head_move_direction_ = MoveDirection.LEFT
  elif Input.get_action_strength(Configs.ACTION_SNAKE_RIGHT):
    head_move_direction_ = MoveDirection.RIGHT
  elif Input.get_action_strength(Configs.ACTION_SNAKE_UP):
    head_move_direction_ = MoveDirection.UP
  elif Input.get_action_strength(Configs.ACTION_SNAKE_DOWN):
    head_move_direction_ = MoveDirection.DOWN
  else:
    return

# Get the tail node of snake
func get_tail_node() -> Area2D:
  if body_cur_length_ == 0:
    return get_head_node()
  return get_body_node(body_cur_length_)

# Get snake head node
func get_head_node() -> Area2D:
  if is_instance_valid(head_node_):
    return head_node_
  for child in self.get_children():
    if child.name == Configs.NODE_NAME_SNAKE_HEAD:
      return child
  return null
  
# Get selected body node
func get_body_node(body_index:int) -> Area2D:
  if body_index < 1 or body_index > body_cur_length_:
    return null
  for child in get_children():
    if body_index == int(child.name.split("_")[-1]):
      return child
  return null

# Append a new snake body to the tail
func add_body_to_tail() -> void:
  var snake_tail = get_tail_node()
  if not is_instance_valid(snake_tail):
    return
  body_cur_length_ += 1
  if (body_cur_length_ >= Configs.SNAKE_BODY_MAX_LENGTH):
    # TODO: End game with success
    return
  var snake_body = load(BODY_SCENE_PATH).instantiate()
  snake_body.name = Configs.NODE_NAME_SNAKE_BODY_PREFIX + str(body_cur_length_)
  snake_body.position = snake_tail.position + Vector2(-Configs.SNAKE_NODE_WIDTH, 0)
  self.add_child(snake_body)
