extends Enemy

enum State {
    IDLE,
    WALK,
    RUN,
}

@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var calm_down_timer: Timer = $CalmDownTimer

func can_see_player() -> bool:
    if not self.player_checker.is_colliding():
        return false
    return self.player_checker.get_collider() is Player

func tick_physics(state: State, delta: float) -> void:
    match state:
        State.IDLE:
            self.move(0, delta)
        State.WALK:
            self.move(self.max_speed / 3, delta)
        State.RUN:
            if self.wall_checker.is_colliding() or not self.floor_checker.is_colliding():
                self.direction = Direction.LEFT if self.direction == Direction.RIGHT else Direction.RIGHT
            self.move(self.max_speed, delta)
            if self.can_see_player():
                self.calm_down_timer.start()

func get_next_state(state: State) -> State:
    if self.can_see_player():
        return State.RUN
    match state:
        State.IDLE:
            if self.state_machine.state_time_ > 2:
                return State.WALK
        State.WALK:
            if self.wall_checker.is_colliding() or not self.floor_checker.is_colliding():
                return State.IDLE
        State.RUN:
            if self.calm_down_timer.is_stopped():
                return State.WALK
    return state

func transition_state(_from: State, to: State) -> void:
    #print("[%s] %s => %s" % [
        #Engine.get_physics_frames(),
        #State.keys()[from] if from != -1 else "<Start>",
        #State.keys()[to],
    #])
    match to:
        State.IDLE:
            self.animation_player.play("idle")
            if self.wall_checker.is_colliding():
                self.direction = Direction.LEFT if self.direction == Direction.RIGHT else Direction.RIGHT
        State.WALK:
            self.animation_player.play("walk")
            if not self.floor_checker.is_colliding():
                self.direction = Direction.LEFT if self.direction == Direction.RIGHT else Direction.RIGHT
                self.floor_checker.force_raycast_update()
        State.RUN:
            self.animation_player.play("run")
