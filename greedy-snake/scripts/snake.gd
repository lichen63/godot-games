extends Node2D

const MOVE_SPEED:int = 5
const INIT_SNAKE_BODY_LENGTH:int = 3
const BODY_SCENE_PATH:String = "res://scenes/snake_body.tscn"

var body_cur_length_:int = 0
var head_node_:Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  head_node_ = get_head_node()
  if not is_instance_valid(head_node_):
    print("[snake::_ready] head_node_ is invalid")
    return
    
  for i in INIT_SNAKE_BODY_LENGTH:
    add_body_to_tail()

func _physics_process(_delta: float) -> void:
  var left_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_LEFT)
  var right_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_RIGHT)
  var up_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_UP)
  var down_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_DOWN)

  var offset = Vector2((right_value - left_value) * MOVE_SPEED, (down_value - up_value) * MOVE_SPEED)
  if offset.is_equal_approx(Vector2(0, 0)):
    return
  offset.normalized()

  var move_path:Array[Vector2] = []
  for child in get_children():
    move_path.push_back(child.position)

  head_node_.position += offset

  var children_count = get_child_count()
  var children = get_children()
  for i in range(1, children_count):
    children[i].position = move_path[i-1]

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
func get_body_node(body_index) -> Area2D:
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
