extends HBoxContainer

@export var stats: Stats = null

@onready var health_bar: TextureProgressBar = $V/HealthBar
@onready var eased_health_bar: TextureProgressBar = $V/HealthBar/EasedHealthBar
@onready var energy_bar: TextureProgressBar = $V/EnergyBar

func _ready() -> void:
    if not self.stats:
        self.stats = Game.player_stats
    self.stats.health_changed.connect(update_health)
    self.update_health(true)
    self.stats.energy_changed.connect(update_energy)
    self.update_energy()
    self.tree_exited.connect(func():
        self.stats.health_changed.disconnect(update_health)
        self.stats.energy_changed.disconnect(update_energy)
    )

func update_health(skip_anim: bool = false) -> void:
    var percentage: float = self.stats.health / float(self.stats.max_health)
    self.health_bar.value = percentage
    if skip_anim:
        self.eased_health_bar.value = percentage
    else:
        self.create_tween().tween_property(self.eased_health_bar, "value", percentage, 0.3)

func update_energy() -> void:
    var percentage: float = self.stats.energy / self.stats.max_energy
    self.energy_bar.value = percentage
