class_name WorldspaceResourceBar
extends UIResourceBar


var _init_position: Vector2


func _ready() -> void:
    _init_position = position
    super()


func _update() -> void:
    position = get_parent().global_position + _init_position
    super()
