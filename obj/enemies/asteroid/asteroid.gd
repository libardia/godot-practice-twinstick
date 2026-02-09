class_name Asteroid
extends RigidBody2D


const GROUP_ASTEROIDS := &"asteroids"

@export var size: int
@export var base_mass: float = 1


func _enter_tree() -> void:
    add_to_group(GROUP_ASTEROIDS)
    mass = base_mass * pow(2, size)
