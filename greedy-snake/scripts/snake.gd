extends Node2D

var snake_body_cur_length:int = 0
const SNAKE_MOVE_SPEED:int = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var snake_tail = get_last_node()
  if !is_instance_valid(snake_tail):
    pass
  snake_body_cur_length += 1
  if (snake_body_cur_length >= Configs.SNAKE_BODY_MAX_LENGTH):
    # TODO: End game with success
    pass
  var snake_body = load("res://scenes/snake_body.tscn").instantiate()
  snake_body.name = Configs.NODE_NAME_SNAKE_BODY_PREFIX + str(snake_body_cur_length)
  snake_body.position = snake_tail.position + Vector2(-Configs.SNAKE_NODE_WIDTH, 0)
  self.add_child(snake_body)

func _physics_process(_delta: float) -> void:
  var left_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_LEFT)
  var right_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_RIGHT)
  var up_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_UP)
  var down_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_DOWN)

  var prev_pos = position
  position.x += (right_value - left_value) * SNAKE_MOVE_SPEED
  position.y += (down_value - up_value) * SNAKE_MOVE_SPEED
  var cur_pos = position
  
  var head_node = get_head_node()
  if is_instance_valid(head_node):
    print("[snake::_physics_process] head_node is invalid")
    pass

# Get the tail node of snake
func get_last_node() -> Area2D:
  for child in self.get_children():
    if snake_body_cur_length == 0 and child.name == Configs.NODE_NAME_SNAKE_HEAD:
      return child
    elif snake_body_cur_length != 0 and snake_body_cur_length == int(child.name.split("_")[-1]):
      return child
  return null

# Get snake head node
func get_head_node() -> Area2D:
  for child in self.get_children():
    if snake_body_cur_length == 0 and child.name == Configs.NODE_NAME_SNAKE_HEAD:
      return child
  return null
