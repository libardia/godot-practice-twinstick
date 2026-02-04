class_name Asteroid
extends RigidBody2D

@export_group("Physics")
@export var size: int = 0
@export var base_mass: float = 2

@export_group("Initial Velocity", "linear_")
@export_custom(PROPERTY_HINT_LINK, "") var linear_min: Vector2
@export_custom(PROPERTY_HINT_LINK, "") var linear_max: Vector2

@export_group("Initial Angular Velocity", "angular_")
@export var angular_min: float
@export var angular_max: float


func _enter_tree() -> void:
    mass = base_mass * pow(2, size)


func _ready() -> void:
    linear_velocity = Vector2(
        lerpf(linear_min.x, linear_max.x, randf()),
        lerpf(linear_min.y, linear_max.y, randf())
    )
    angular_velocity = lerpf(angular_min, angular_max, randf())
