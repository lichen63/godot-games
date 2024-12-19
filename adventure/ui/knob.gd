extends TouchScreenButton

const DRAG_RADIUS: float = 16.0

var finger_index: int = -1
var drag_offset: Vector2 = Vector2.ZERO

@onready var reset_pos: Vector2 = self.global_position

func _input(event: InputEvent) -> void:
    var st := event as InputEventScreenTouch
    if st:
        if st.pressed and finger_index == -1:
            var global_pos: Vector2 = st.position * get_canvas_transform()
            var local_pos: Vector2 = global_pos * get_global_transform()
            var rect: Rect2 = Rect2(Vector2.ZERO, self.texture_normal.get_size())
            if rect.has_point(local_pos):
                # down
                finger_index = st.index
                self.drag_offset = global_pos - self.global_position
        elif not st.pressed and st.index == finger_index:
            # up
            Input.action_release("move_left")
            Input.action_release("move_right")
            finger_index = -1
            self.global_position = self.reset_pos
    
    var sd := event as InputEventScreenDrag
    if sd and sd.index == finger_index:
        # drag
        var wish_pos: Vector2 = sd.position * get_canvas_transform() - self.drag_offset
        var movement: Vector2 = (wish_pos - self.reset_pos).limit_length(DRAG_RADIUS)
        self.global_position = self.reset_pos + movement
        movement /= DRAG_RADIUS
        if movement.x > 0:
            Input.action_release("move_left")
            Input.action_press("move_right", movement.x)
        elif movement.x < 0:
            Input.action_release("move_right")
            Input.action_press("move_left", -movement.x)
