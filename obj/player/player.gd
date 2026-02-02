class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var max_speed: float = 750
@export var drag_coeff: float = 0.3
@export var mass: float = 10

@export_group("Rotation", "rotation_")
@export var rotation_lerp_factor: float = 3
@export var rotation_ease_factor: float = 0.2

@export_group("Bullets", "bullet_")
@export var bullet_pass_velocity: bool = true

@onready var turrets: Array[Turret] = [$Turret1, $Turret2]
@onready var fire_cooldown: Timer = $FireCooldown

var move_force: float
var target_angle: float


func _ready() -> void:
    # Calculated to ensure max speed
    move_force = max_speed * drag_coeff


func _process(delta: float) -> void:
    rotation = lerp_angle(
        rotation, target_angle,
        ease(rotation_lerp_factor * delta, rotation_ease_factor)
    )


func _physics_process(_delta: float) -> void:
    var move_dir = Input.get_vector(&"move left", &"move right", &"move up", &"move down")
    var aim_dir: Vector2

    var should_mouse_aim = InputDetector.is_mkb() and Settings.mouse_aim
    var fire_on_button = should_mouse_aim or Settings.separate_fire_button

    if should_mouse_aim:
        aim_dir = position.direction_to(get_global_mouse_position())
    else:
        aim_dir = Input.get_vector(&"aim left", &"aim right", &"aim up", &"aim down")

    if fire_on_button:
        if Input.is_action_just_pressed(&"fire"): start_firing()
        elif Input.is_action_just_released(&"fire"): stop_firing()
    else:
        if not aim_dir.is_zero_approx(): start_firing()
        else: stop_firing()

    if not aim_dir.is_zero_approx():
        aim(aim_dir)
    else:
        aim(transform.x)

    if not move_dir.is_zero_approx():
        target_angle = move_dir.angle()

    # Movement
    var forces = move_dir * move_force
    # Drag
    forces += -velocity * drag_coeff

    velocity += forces / mass
    move_and_slide()


func start_firing():
    if fire_cooldown.is_stopped():
        fire()
        fire_cooldown.start()


func stop_firing():
    if not fire_cooldown.is_stopped():
        fire_cooldown.stop()


func aim(direction: Vector2):
    for t in turrets:
        t.aim(direction)


func fire():
    for t in turrets:
        if bullet_pass_velocity:
            t.fire(velocity)
        else:
            t.fire()
