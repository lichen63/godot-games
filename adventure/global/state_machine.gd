class_name StateMachine
extends Node

var cur_state_: int = -1:
    set(v):
        self.owner.transition_state(cur_state_, v)
        cur_state_ = v

func _ready() -> void:
    await self.owner.ready
    self.cur_state_ = 0

func _physics_process(delta: float) -> void:
    while true:
        var next_state: int = self.owner.get_next_state(self.cur_state_)
        if self.cur_state_ == next_state:
            break
        self.cur_state_ = next_state
    self.owner.tick_physics(self.cur_state_, delta)
