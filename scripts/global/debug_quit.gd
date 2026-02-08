extends Node


func _input(event: InputEvent) -> void:
    if event.is_action(&"debug quit"):
        get_tree().quit(0)
