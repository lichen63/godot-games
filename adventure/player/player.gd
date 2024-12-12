class_name Player
extends CharacterBody2D

enum State {
    IDLE,
    RUNNING,
    JUMP,
    FALL,
    LANDING,
    WALL_SLIDING,
    WALL_JUMP,
    ATTACK_1,
    ATTACK_2,
    ATTACK_3,
    HURT,
    DYING,
}

const RUN_SPEED: float = 160.0
const ACCELERATION_FLOOR: float = RUN_SPEED / 0.2
const ACCELERATION_AIR: float = RUN_SPEED / 0.1
const JUMP_VELOCITY: float = -360.0
const WALL_JUMP_VELOCITY: Vector2 = Vector2(400, -320.0)
const GROUND_STATES: Array = [State.IDLE, State.RUNNING, State.LANDING, State.ATTACK_1, State.ATTACK_2, State.ATTACK_3]
const KNOCKBACK_AMOUNT: int = 512

@export var can_combo: bool = false

var default_gravity: float = ProjectSettings.get("physics/2d/default_gravity")
var is_first_tick: bool = false
var is_combo_requested: bool = false
var pending_damage: Damage = null

@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var hand_checker: RayCast2D = $Graphics/HandChecker
@onready var foot_checker: RayCast2D = $Graphics/FootChecker
@onready var state_machine: StateMachine = $StateMachine
@onready var stats: Stats = $Stats
@onready var invincible_timer: Timer = $InvincibleTimer

func tick_physics(state: State, delta: float) -> void:
    if self.invincible_timer.time_left > 0:
        self.graphics.modulate.a = sin(Time.get_ticks_msec() / 20) * 0.5 + 0.5
    else:
        self.graphics.modulate.a = 1
    match state:
        State.IDLE:
            self.move(self.default_gravity, delta)
        State.RUNNING:
            self.move(self.default_gravity, delta)
        State.JUMP:
            self.move(0.0 if self.is_first_tick else self.default_gravity, delta)
        State.FALL:
            self.move(self.default_gravity, delta)
        State.LANDING:
            self.stand(self.default_gravity, delta)
        State.WALL_SLIDING:
            self.move(self.default_gravity / 3, delta)
            self.graphics.scale.x = self.get_wall_normal().x
        State.WALL_JUMP:
            if self.state_machine.state_time < 0.1:
                self.stand(0.0 if self.is_first_tick else self.default_gravity, delta)
                self.graphics.scale.x = self.get_wall_normal().x
            else:
                move(self.default_gravity, delta)
        State.ATTACK_1, State.ATTACK_2, State.ATTACK_3:
            self.stand(self.default_gravity, delta)
        State.HURT, State.DYING:
            self.stand(self.default_gravity, delta)
    self.is_first_tick = false

func move(gravity: float, delta: float) -> void:
    var direction: float = Input.get_axis("move_left", "move_right")
    var acceleration: float = ACCELERATION_FLOOR if self.is_on_floor() else ACCELERATION_AIR
    self.velocity.x = move_toward(self.velocity.x, direction * RUN_SPEED, acceleration * delta)
    self.velocity.y += gravity * delta

    if not is_zero_approx(direction):
        self.graphics.scale.x = -1 if direction < 0 else + 1
    self.move_and_slide()

func stand(gravity: float, delta: float) -> void:
    var acceleration: float = ACCELERATION_FLOOR if self.is_on_floor() else ACCELERATION_AIR
    self.velocity.x = move_toward(self.velocity.x, 0.0, acceleration * delta)
    self.velocity.y += gravity * delta
    self.move_and_slide()

func die() -> void:
    self.get_tree().reload_current_scene()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
        jump_request_timer.start()
    if event.is_action_released("jump"):
        jump_request_timer.stop()
        if self.velocity.y < JUMP_VELOCITY / 2:
            self.velocity.y = JUMP_VELOCITY / 2
    if event.is_action_pressed("attack") and self.can_combo:
        self.is_combo_requested = true

func can_wall_slide() -> bool:
    return self.is_on_wall() and self.hand_checker.is_colliding() and self.foot_checker.is_colliding()

func get_next_state(state: State) -> int:
    if self.stats.health == 0:
        return StateMachine.KEEP_CURRENT if state == State.DYING else State.DYING
    if self.pending_damage:
        return State.HURT
    var can_jump: bool = self.is_on_floor() or coyote_timer.time_left > 0
    var should_jump: bool = can_jump and jump_request_timer.time_left > 0
    if should_jump:
        return State.JUMP
    if state in GROUND_STATES and not self.is_on_floor():
        return State.FALL
    var direction: float = Input.get_axis("move_left", "move_right")
    var is_still: bool = is_zero_approx(direction) and is_zero_approx(self.velocity.x)
    match state:
        State.IDLE:
            if Input.is_action_just_pressed("attack"):
                return State.ATTACK_1
            if not is_still:
                return State.RUNNING
        State.RUNNING:
            if Input.is_action_just_pressed("attack"):
                return State.ATTACK_1
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
            if not self.animation_player.is_playing():
                return State.IDLE
        State.WALL_SLIDING:
            if self.jump_request_timer.time_left > 0:
                return State.WALL_JUMP
            if self.is_on_floor():
                return State.IDLE
            if not self.is_on_wall():
                return State.FALL
        State.WALL_JUMP:
            if self.can_wall_slide() and not self.is_first_tick:
                return State.WALL_SLIDING
            if self.velocity.y >= 0:
                return State.FALL
        State.ATTACK_1:
            if not self.animation_player.is_playing():
                return State.ATTACK_2 if self.is_combo_requested else State.IDLE
        State.ATTACK_2:
            if not self.animation_player.is_playing():
                return State.ATTACK_3 if self.is_combo_requested else State.IDLE
        State.ATTACK_3:
            if not self.animation_player.is_playing():
                return State.IDLE
        State.HURT:
            if not self.animation_player.is_playing():
                return State.IDLE
    return StateMachine.KEEP_CURRENT

func transition_state(from: State, to: State) -> void:
    #print("[%s] %s => %s" % [
        #Engine.get_physics_frames(),
        #State.keys()[from] if from != -1 else "<Start>",
        #State.keys()[to],
    #])
    if from in GROUND_STATES and to in GROUND_STATES:
        self.coyote_timer.stop()
    match to:
        State.IDLE:
            self.animation_player.play("idle")
        State.RUNNING:
            self.animation_player.play("running")
        State.JUMP:
            self.animation_player.play("jump")
            self.velocity.y = JUMP_VELOCITY
            coyote_timer.stop()
            jump_request_timer.stop()
        State.FALL:
            self.animation_player.play("fall")
            if from in GROUND_STATES:
                self.coyote_timer.start()
        State.LANDING:
            self.animation_player.play("landing")
        State.WALL_SLIDING:
            self.animation_player.play("wall_sliding")
        State.WALL_JUMP:
            self.animation_player.play("jump")
            self.velocity = WALL_JUMP_VELOCITY
            self.velocity.x *= self.get_wall_normal().x
            jump_request_timer.stop()
        State.ATTACK_1:
            self.animation_player.play("attack_1")
            self.is_combo_requested = false
        State.ATTACK_2:
            self.animation_player.play("attack_2")
            self.is_combo_requested = false
        State.ATTACK_3:
            self.animation_player.play("attack_3")
            self.is_combo_requested = false
        State.HURT:
            self.animation_player.play("hurt")
            self.stats.health -= self.pending_damage.amount
            var dir: Vector2 = self.pending_damage.source.global_position.direction_to(self.global_position)
            self.velocity = dir * KNOCKBACK_AMOUNT
            self.pending_damage = null
            self.invincible_timer.start()
        State.DYING:
            self.animation_player.play("die")
            self.invincible_timer.stop()
    self.is_first_tick = true

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
    if self.invincible_timer.time_left > 0:
        return
    self.pending_damage = Damage.new()
    self.pending_damage.amount = 1
    self.pending_damage.source = hitbox.owner
