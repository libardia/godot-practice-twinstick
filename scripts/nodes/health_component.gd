class_name HealthComponent
extends Component


const GROUP_HAS_HEALTH := &"has_health"

signal health_depleted

@export var current_health: float
@export var max_health: float
@export var capped: bool
@export var free_when_depleted: bool


func _enter_tree() -> void:
    super._enter_tree()
    belongs_to.add_to_group(GROUP_HAS_HEALTH)


func damage(amount: float):
    adjust(-amount)


func heal(amount: float):
    adjust(amount)


func adjust(amount: float):
    current_health += amount
    if capped and current_health > max_health:
        current_health = max_health
    if current_health <= 0:
        health_depleted.emit()
        if free_when_depleted:
            belongs_to.queue_free()
