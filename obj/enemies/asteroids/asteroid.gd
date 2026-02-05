class_name Asteroid
extends RigidBody2D

@export_group("Physics")
@export var size: int = 0
@export var base_mass: float = 2

@export_group("Initial Velocity", "linear_")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var linear_min: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var linear_max: float

@export_group("Initial Angular Velocity", "angular_")
@export_custom(PROPERTY_HINT_NONE, "suffix:rad/s") var angular_min: float
@export_custom(PROPERTY_HINT_NONE, "suffix:rad/s") var angular_max: float


func _enter_tree() -> void:
    mass = base_mass * pow(2, size)


func _ready() -> void:
    # random speed in a random direction
    var speed = lerpf(linear_min, linear_max, randf())
    var angle = lerpf(0, TAU, randf())
    linear_velocity = Vector2.RIGHT.rotated(angle) * speed
    # random angular velocity, 50/50 positive or negative
    angular_velocity = lerpf(angular_min, angular_max, randf())
    if randi_range(0, 1): angular_velocity *= -1
