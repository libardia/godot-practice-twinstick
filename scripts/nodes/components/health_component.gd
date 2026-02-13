class_name HealthComponent
extends Component


const UNIQUE_NAME := ^"%HealthComponent"

signal health_depleted
signal changed(amount: float, before: float)

## The health this entity currently has.
@export var current_health: float
## The maximum health of this entity. If [member capped] is [code]true[/code],
## [member current_health] will be clamped to this value.
@export var max_health: float
## If [memner current_health] should be capped at [member max_health]. When [code]true[/code],
## [member current_health] is clamped to [member max_health].
@export var capped: bool = false
## When [code]true[/code], the health of this entity cannot be changed.
@export var locked: bool = false
@export_group("When Depleted", "when_depleted_")
## If this entity should automatically lock when depleted for the first time, preventing changes.
## If necessary, the health can be unlocked by setting [member locked] to [code]false[/code].
@export var when_depleted_lock: bool = true
## If this entity should be freed when health is depleted. Specifically,
## [code]belongs_to.queue_free()[/code] will be called.
@export var when_depleted_free_owner: bool = false


func damage(amount: float):
    adjust(-amount)


func heal(amount: float):
    adjust(amount)


func adjust(amount: float):
    if not locked:
        var before = current_health
        current_health += amount
        if capped and current_health > max_health:
            current_health = max_health
        changed.emit(amount, before)
        if before > 0 and current_health <= 0:
            if when_depleted_lock:
                locked = true
            health_depleted.emit()
            if when_depleted_free_owner:
                belongs_to.queue_free()
