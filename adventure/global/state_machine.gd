class_name StateMachine
extends Node

const KEEP_CURRENT: int = -1

var cur_state: int = -1:
    set(v):
        self.owner.transition_state(cur_state, v)
        cur_state = v
        self.state_time = 0
var state_time: float

func _ready() -> void:
    await self.owner.ready
    self.cur_state = 0

func _physics_process(delta: float) -> void:
    while true:
        var next_state: int = self.owner.get_next_state(self.cur_state)
        if next_state == self.KEEP_CURRENT:
            break
        self.cur_state = next_state
    self.owner.tick_physics(self.cur_state, delta)
    self.state_time += delta
