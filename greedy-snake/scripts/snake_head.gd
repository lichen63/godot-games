extends Area2D


const SPEED:int = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Configs.GROUP_NAME_SNAKE)
  self.name = Configs.NODE_NAME_SNAKE_HEAD

func _physics_process(_delta: float) -> void:
  var left_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_LEFT)
  var right_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_RIGHT)
  var up_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_UP)
  var down_value:float = Input.get_action_strength(Configs.ACTION_SNAKE_DOWN)

  position.x += (right_value - left_value) * SPEED
  position.y += (down_value - up_value) * SPEED

func _on_area_entered(area: Area2D) -> void:
  if area.is_in_group(Configs.GROUP_NAME_WALLS) or area.is_in_group(Configs.GROUP_NAME_SNAKE):
    #TODO: End the game with failure
    reset_pos()

func reset_pos() -> void:
  position = get_viewport().size / 2
