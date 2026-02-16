class_name Turret
extends Node2D


@export_group("Bullet", "bullet_")
@export var bullet_scene: PackedScene
@export var bullet_speed: float

@export_group("Aim", "aim_")
@export var smooth_aim: bool = true
@export var aim_lerp_factor: float
@export var aim_ease_factor: float

@onready var gun: Node2D = $Gun
@onready var fire_points: Array[Marker2D]

var target_angle: float


func _ready() -> void:
    fire_points.assign(%FirePoints.get_children())


func aim(direction: Vector2) -> void:
    if smooth_aim:
        target_angle = direction.angle()
    else:
        gun.global_rotation = direction.angle()


func fire(extra_velocity: Vector2 = Vector2.ZERO) -> void:
    for point in fire_points:
        var fire_xform := point.global_transform
        var bullet_vel := extra_velocity + (fire_xform.x * bullet_speed)
        BulletManager.fire(bullet_scene, fire_xform, bullet_vel)


func _process(delta: float) -> void:
    if smooth_aim:
        gun.global_rotation = lerp_angle(
            gun.global_rotation, target_angle,
            ease(aim_lerp_factor * delta, aim_ease_factor)
        )
