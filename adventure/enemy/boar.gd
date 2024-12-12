extends Enemy

enum State {
    IDLE,
    WALK,
    RUN,
    HURT,
    DYING,
}

const KNOCKBACK_AMOUNT: int = 512

var pending_damage: Damage = null

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
        State.IDLE, State.HURT, State.DYING:
            self.move(0, delta)
        State.WALK:
            self.move(self.max_speed / 3, delta)
        State.RUN:
            if self.wall_checker.is_colliding() or not self.floor_checker.is_colliding():
                self.direction = Direction.LEFT if self.direction == Direction.RIGHT else Direction.RIGHT
            self.move(self.max_speed, delta)
            if self.can_see_player():
                self.calm_down_timer.start()

func get_next_state(state: State) -> int:
    if self.stats.health == 0:
        return StateMachine.KEEP_CURRENT if state == State.DYING else State.DYING
    if self.pending_damage:
        return State.HURT
    match state:
        State.IDLE:
            if self.can_see_player():
                return State.RUN
            if self.state_machine.state_time > 2:
                return State.WALK
        State.WALK:
            if self.can_see_player():
                return State.RUN
            if self.wall_checker.is_colliding() or not self.floor_checker.is_colliding():
                return State.IDLE
        State.RUN:
            if not self.can_see_player() and self.calm_down_timer.is_stopped():
                return State.WALK
        State.HURT:
            if not self.animation_player.is_playing():
                return State.RUN
    return StateMachine.KEEP_CURRENT

func transition_state(_from: State, to: State) -> void:
    # print("[%s] %s => %s" % [
    #     Engine.get_physics_frames(),
    #     State.keys()[from] if from != -1 else "<Start>",
    #     State.keys()[to],
    # ])
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
        State.HURT:
            self.animation_player.play("hit")
            self.stats.health -= self.pending_damage.amount
            var dir: Vector2 = self.pending_damage.source.global_position.direction_to(self.global_position)
            self.velocity = dir * KNOCKBACK_AMOUNT
            self.direction = Direction.LEFT if dir.x > 0 else Direction.RIGHT
            self.pending_damage = null
        State.DYING:
            self.animation_player.play("die")

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
    self.pending_damage = Damage.new()
    self.pending_damage.amount = 1
    self.pending_damage.source = hitbox.owner
