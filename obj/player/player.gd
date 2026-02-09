class_name Player
extends RigidBody2D


@export_group("Movement")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var max_speed: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s²") var acceleration: float
@export_group("Rotation", "rotation_")
@export var rotation_lerp_factor: float
@export var rotation_ease_factor: float
@export var rotation_aim_by_rotation: bool = false
@export_group("Bullets", "bullet_")
@export var bullet_include_velocity: bool = true
@export var bullet_project_velocity: bool = true

@onready var fire_cooldown: Timer = %FireCooldown
@onready var turrets: Array[Turret]
@onready var health_component: HealthComponent = %HealthComponent

var move_force: float
var drag_coeff: float
var target_angle: float
var aim_dir: Vector2


func _ready() -> void:
    GlobalData.player = self
    turrets.assign(%Turrets.get_children())
    move_force = acceleration * mass
    drag_coeff = move_force / pow(max_speed, 1)


func _physics_process(_delta: float) -> void:
    var move_dir = Input.get_vector(&"move left", &"move right", &"move up", &"move down")

    var should_mouse_aim = InputDetector.is_mkb() and Settings.mouse_aim
    var fire_on_button = should_mouse_aim or Settings.separate_fire_button

    if should_mouse_aim:
        aim_dir = position.direction_to(get_global_mouse_position())
    else:
        aim_dir = Input.get_vector(&"aim left", &"aim right", &"aim up", &"aim down")

    var move_zero = move_dir.is_zero_approx()
    var aim_zero = aim_dir.is_zero_approx()

    if fire_on_button:
        if Input.is_action_pressed(&"fire"): start_firing()
        else: stop_firing()
    else:
        if aim_zero: stop_firing()
        else: start_firing()

    if rotation_aim_by_rotation:
        if aim_zero and not move_zero:
            target_angle = move_dir.angle()
        elif not aim_zero:
            target_angle = aim_dir.angle()
    else:
        if not aim_zero:
            aim_turrets(aim_dir)
        else:
            aim_turrets(transform.x)

    constant_force = Vector2.ZERO
    constant_force += move_dir * move_force
    constant_force += -linear_velocity * drag_coeff


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
    rotation = lerp_angle(
        rotation, target_angle,
        ease(rotation_lerp_factor * get_physics_process_delta_time(), rotation_ease_factor)
    )


func start_firing():
    if fire_cooldown.is_stopped():
        fire()
        fire_cooldown.start()


func stop_firing():
    if not fire_cooldown.is_stopped():
        fire_cooldown.stop()


func aim_turrets(direction: Vector2):
    for t in turrets:
        t.aim(direction)


func fire():
    for t in turrets:
        if bullet_include_velocity:
            if bullet_project_velocity:
                t.fire(linear_velocity.project(aim_dir))
            else:
                t.fire(linear_velocity)
        else:
            t.fire()
