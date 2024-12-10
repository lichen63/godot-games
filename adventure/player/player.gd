extends CharacterBody2D

enum State {
    IDLE,
    RUNNING,
    JUMP,
    FALL,
    LANDING,
    WALL_SLIDING,
    WALL_JUMP,
}

const RUN_SPEED: float = 160.0
const ACCELERATION_FLOOR: float = RUN_SPEED / 0.2
const ACCELERATION_AIR: float = RUN_SPEED / 0.1
const JUMP_VELOCITY: float = -360.0
const WALL_JUMP_VELOCITY: Vector2 = Vector2(400, -320.0)
const GROUND_STATES: Array = [State.IDLE, State.RUNNING, State.LANDING]

var default_gravity_: float = ProjectSettings.get("physics/2d/default_gravity")
var is_first_tick_: bool = false

@onready var graphics_: Node2D = $Graphics
@onready var animation_player_: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer_: Timer = $CoyoteTimer
@onready var jump_request_timer_: Timer = $JumpRequestTimer
@onready var hand_checker_: RayCast2D = $Graphics/HandChecker
@onready var foot_checker_: RayCast2D = $Graphics/FootChecker
@onready var state_machine_: StateMachine = $StateMachine

func tick_physics(state: State, delta: float) -> void:
    match state:
        State.IDLE:
            self.move(self.default_gravity_, delta)
        State.RUNNING:
            self.move(self.default_gravity_, delta)
        State.JUMP:
            self.move(0.0 if self.is_first_tick_ else self.default_gravity_, delta)
        State.FALL:
            self.move(self.default_gravity_, delta)
        State.LANDING:
            self.stand(self.default_gravity_, delta)
        State.WALL_SLIDING:
            self.move(self.default_gravity_ / 3, delta)
            self.graphics_.scale.x = self.get_wall_normal().x
        State.WALL_JUMP:
            if self.state_machine_.state_time_ < 0.1:
                self.stand(0.0 if self.is_first_tick_ else self.default_gravity_, delta)
                self.graphics_.scale.x = self.get_wall_normal().x
            else:
                move(self.default_gravity_, delta)
    self.is_first_tick_ = false

func move(gravity: float, delta: float) -> void:
    var direction: float = Input.get_axis("move_left", "move_right")
    var acceleration: float = ACCELERATION_FLOOR if self.is_on_floor() else ACCELERATION_AIR
    self.velocity.x = move_toward(self.velocity.x, direction * RUN_SPEED, acceleration * delta)
    self.velocity.y += gravity * delta

    if not is_zero_approx(direction):
        self.graphics_.scale.x = -1 if direction < 0 else +1
    self.move_and_slide()

func stand(gravity: float, delta: float) -> void:
    var acceleration: float = ACCELERATION_FLOOR if self.is_on_floor() else ACCELERATION_AIR
    self.velocity.x = move_toward(self.velocity.x, 0.0, acceleration * delta)
    self.velocity.y += gravity * delta
    self.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
        jump_request_timer_.start()
    if event.is_action_released("jump"):
        jump_request_timer_.stop()
        if self.velocity.y < JUMP_VELOCITY / 2:
            self.velocity.y = JUMP_VELOCITY / 2

func can_wall_slide() -> bool:
    return self.is_on_wall() and self.hand_checker_.is_colliding() and self.foot_checker_.is_colliding()

func get_next_state(state: State) -> State:
    var can_jump: bool = self.is_on_floor() or coyote_timer_.time_left > 0
    var should_jump: bool = can_jump and jump_request_timer_.time_left > 0
    if should_jump:
        return State.JUMP
    var direction: float = Input.get_axis("move_left", "move_right")
    var is_still: bool = is_zero_approx(direction) and is_zero_approx(self.velocity.x)
    match state:
        State.IDLE:
            if not self.is_on_floor():
                return State.FALL
            if not is_still:
                return State.RUNNING
        State.RUNNING:
            if not self.is_on_floor():
                return State.FALL
            if is_still:
                return State.IDLE
        State.JUMP:
            if self.velocity.y >= 0:
                return State.FALL
        State.FALL:
            if self.is_on_floor():
                return State.LANDING if is_still else State.RUNNING
            if self.can_wall_slide():
                return State.WALL_SLIDING
        State.LANDING:
            if not is_still:
                return State.RUNNING
            if not self.animation_player_.is_playing():
                return State.IDLE
        State.WALL_SLIDING:
            if self.jump_request_timer_.time_left > 0:
                return State.WALL_JUMP
            if self.is_on_floor():
                return State.IDLE
            if not self.is_on_wall():
                return State.FALL
        State.WALL_JUMP:
            if self.can_wall_slide() and not self.is_first_tick_:
                return State.WALL_SLIDING
            if self.velocity.y >= 0:
                return State.FALL
    return state

func transition_state(from: State, to: State) -> void:
    #print("[%s] %s => %s" % [
        #Engine.get_physics_frames(),
        #State.keys()[from] if from != -1 else "<Start>",
        #State.keys()[to],
    #])
    if from in GROUND_STATES and to in GROUND_STATES:
        self.coyote_timer_.stop()
    match to:
        State.IDLE:
            self.animation_player_.play("idle")
        State.RUNNING:
            self.animation_player_.play("running")
        State.JUMP:
            self.animation_player_.play("jump")
            self.velocity.y = JUMP_VELOCITY
            coyote_timer_.stop()
            jump_request_timer_.stop()
        State.FALL:
            self.animation_player_.play("fall")
            if from in GROUND_STATES:
                self.coyote_timer_.start()
        State.LANDING:
            self.animation_player_.play("landing")
        State.WALL_SLIDING:
            self.animation_player_.play("wall_sliding")
        State.WALL_JUMP:
            self.animation_player_.play("jump")
            self.velocity = WALL_JUMP_VELOCITY
            self.velocity.x *= self.get_wall_normal().x
            jump_request_timer_.stop()
    self.is_first_tick_ = true
