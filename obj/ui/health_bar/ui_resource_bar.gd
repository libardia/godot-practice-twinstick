class_name UIResourceBar
extends TextureProgressBar


@export var tracking: ResourceComponent
@export var hide_when_full: bool = true


func _ready() -> void:
    _update()


func _process(_delta: float) -> void:
    _update()


func _update() -> void:
    max_value = tracking.max_value
    value = tracking.current
    visible = not (hide_when_full and tracking.is_full())
