extends Node2D

var snake_body_cur_length:int = 0
const SNAKE_MOVE_SPEED:int = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var snake_tail = get_tail_node()
  if !is_instance_valid(snake_tail):
    return
  snake_body_cur_length += 1
  if (snake_body_cur_length >= Configs.SNAKE_BODY_MAX_LENGTH):
    # TODO: End game with success
    return
  var snake_body = load("res://scenes/snake_body.tscn").instantiate()
  snake_body.name = Configs.NODE_NAME_SNAKE_BODY_PREFIX + str(snake_body_cur_length)
  snake_body.position = snake_tail.position + Vector2(-Configs.SNAKE_NODE_WIDTH, 0)
  self.add_child(snake_body)

func _physics_process(_delta: float) -> void:
  var left_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_LEFT)
  var right_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_RIGHT)
  var up_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_UP)
  var down_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_DOWN)
  
  var head_node = get_head_node()
  if is_instance_valid(head_node):
    print("[snake::_physics_process] head_node is invalid")
    return
  
  var prev_pos = head_node.position
  head_node.position += Vector2((right_value - left_value) * SNAKE_MOVE_SPEED, (down_value - up_value) * SNAKE_MOVE_SPEED)

  var body_index = 1;
  while (body_index <= snake_body_cur_length):
    var body_node = get_body_node(body_index)
    if (!is_instance_valid(body_node)):
      break
    var temp_pos = body_node.position
    body_node.position = prev_pos
    prev_pos = temp_pos
    body_index += 1

# Get the tail node of snake
func get_tail_node() -> Area2D:
  if snake_body_cur_length == 0:
    return get_node_or_null(Configs.NODE_NAME_SNAKE_HEAD)
  return get_node_or_null(Configs.NODE_NAME_SNAKE_BODY_PREFIX + str(snake_body_cur_length))

# Get snake head node
func get_head_node() -> Area2D:
  return get_node_or_null(Configs.NODE_NAME_SNAKE_HEAD)
  
# Get selected body node
func get_body_node(body_index) -> Area2D:
  return get_node_or_null(Configs.NODE_NAME_SNAKE_BODY_PREFIX + str(body_index))
