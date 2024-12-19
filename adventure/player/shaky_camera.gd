extends Camera2D

@export var recovery_speed: float = 16.0

var strength: float = 0.0

func _ready() -> void:
    Game.camera_should_shake.connect(func(amount: float):
        self.strength += amount
    )

func _process(delta: float) -> void:
    self.offset = Vector2(
        randf_range(-self.strength, +self.strength),
        randf_range(-self.strength, +self.strength),
    )
    self.strength = move_toward(self.strength, 0, self.recovery_speed * delta)
