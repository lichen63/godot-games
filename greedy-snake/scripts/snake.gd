extends Node2D

var snake_body_cur_length:int = 0

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

# Get the tail node of snake
func get_last_node() -> Area2D:
  for child in self.get_children():
    if snake_body_cur_length == 0 and child.name == Configs.NODE_NAME_SNAKE_HEAD:
      return child
    elif snake_body_cur_length != 0 and snake_body_cur_length == int(child.name.split("_")[-1]):
      return child
  return null
