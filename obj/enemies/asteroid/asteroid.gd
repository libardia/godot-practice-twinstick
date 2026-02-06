class_name Asteroid
extends RigidBody2D


@export var size: int
@export var base_mass: float = 1


func _enter_tree() -> void:
    mass = base_mass * pow(2, size)
