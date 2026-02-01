class_name Player
extends CharacterBody2D


@export_group("Movement")
@export var max_speed: float = 750
@export var drag_coeff: float = 0.3
@export var mass: float = 10

@export_group("Rotation")
@export var rotation_lerp_factor: float = 15

@onready var camera: Camera2D = $Camera2D

var move_force: float
var target_angle: float


func _ready() -> void:
    # Calculated to ensure max speed
    move_force = max_speed * drag_coeff


func _process(delta: float) -> void:
    rotation = lerp_angle(rotation, target_angle, rotation_lerp_factor * delta)


func _physics_process(_delta: float) -> void:
    var move_dir = Input.get_vector(&"move left", &"move right", &"move up", &"move down")
    var look_dir: Vector2

    if Settings.mouse_aim and InputDetector.is_mkb():
        look_dir = position.direction_to(get_global_mouse_position())
    else:
        look_dir = Input.get_vector(&"aim left", &"aim right", &"aim up", &"aim down")

    if look_dir.is_zero_approx():
        if not move_dir.is_zero_approx():
            target_angle = move_dir.angle()
    else:
        target_angle = look_dir.angle()

    # Movement
    var forces = move_dir * move_force
    # Drag
    forces += -velocity * drag_coeff

    velocity += forces / mass
    move_and_slide()
