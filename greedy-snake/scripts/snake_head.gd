extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var left_value = Input.get_action_strength("snake_left")
	var right_value = Input.get_action_strength("snake_right")
	var up_value = Input.get_action_strength("snake_up")
	var down_value = Input.get_action_strength("snake_down")

	position.x += (right_value - left_value) * 2
	position.y += (down_value - up_value) * 2
