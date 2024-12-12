extends HBoxContainer

@export var stats: Stats = null

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var eased_health_bar: TextureProgressBar = $HealthBar/EasedHealthBar

func _ready() -> void:
    self.stats.health_changed.connect(update_health)
    self.update_health()

func update_health() -> void:
    var percentage: float = self.stats.health / float(self.stats.max_health)
    self.health_bar.value = percentage
    self.create_tween().tween_property(self.eased_health_bar, "value", percentage, 0.3)
