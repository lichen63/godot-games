class_name Stats
extends Node

signal health_changed

@export var max_health: int = 3

@onready var health:int = max_health:
    set(v):
        health = clampi(v, 0, max_health)
        self.health_changed.emit()
