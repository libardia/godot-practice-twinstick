class_name HealthBar
extends ProgressBar


@export var tracking: HealthComponent
@export var hide_when_full: bool = true

var _init_position: Vector2


func _ready() -> void:
    _init_position = position
    _update()


func _process(_delta: float) -> void:
    _update()


func _update() -> void:
    position = get_parent().global_position + _init_position
    max_value = tracking.max_health
    value = tracking.current_health
    visible = not (hide_when_full and tracking.is_full())
