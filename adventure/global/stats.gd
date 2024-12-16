class_name Stats
extends Node

signal health_changed
signal energy_changed

@export var max_health: int = 3
@export var max_energy: float = 10
@export var energy_regen: float = 0.8

@onready var health: int = max_health:
    set(v):
        v = clampi(v, 0, max_health)
        if health == v:
            return
        health = v
        self.health_changed.emit()

@onready var energy: float = max_energy:
    set(v):
        v = clampf(v, 0, max_energy)
        if energy == v:
            return
        energy = v
        self.energy_changed.emit()

func _process(delta: float) -> void:
    self.energy += self.energy_regen * delta

func to_dict() -> Dictionary:
    return {
        "health": self.health,
        "energy": self.energy,
        "max_health": self.max_health,
        "max_energy": self.max_energy,
    }

func from_dict(data: Dictionary) -> void:
    self.max_energy = data["max_energy"]
    self.max_health = data["max_health"]
    self.energy = data["energy"]
    self.health = data["health"]

func reset() -> void:
    self.health = self.max_health
    self.energy = self.max_energy
