class_name Asteroid
extends RigidBody2D


const GROUP := &"asteroid"

@export var size: int
@export var base_mass: float = 1


func _enter_tree() -> void:
    add_to_group(GROUP)
    mass = base_mass * pow(2, size)
