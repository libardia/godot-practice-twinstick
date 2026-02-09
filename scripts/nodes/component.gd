@abstract class_name Component
extends Node


@export var belongs_to: Node


func _enter_tree() -> void:
    if not belongs_to:
        belongs_to = get_parent()
