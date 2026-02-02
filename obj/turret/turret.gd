class_name Turret
extends Node2D


@export_group("Bullet", "bullet_")
@export var bullet_scene: PackedScene
@export var bullet_speed: float

@export_group("Aim", "aim_")
@export var smooth_aim: bool = true
@export var aim_lerp_factor: float = 5
@export var aim_ease_factor: float = 0.2

@onready var gun: Node2D = $Gun
@onready var fire_position: Marker2D = $Gun/FirePosition

var target_angle: float


func aim(direction: Vector2):
    if smooth_aim:
        target_angle = direction.angle()
    else:
        gun.global_rotation = direction.angle()


func fire(extra_velocity: Vector2 = Vector2.ZERO):
    var fire_xform = fire_position.global_transform
    var bullet_vel = extra_velocity + fire_xform.x * bullet_speed
    BulletManager.fire(bullet_scene, fire_xform, bullet_vel, NodeUtil.absolute_z(fire_position))


func _process(delta: float) -> void:
    if smooth_aim:
        gun.global_rotation = lerp_angle(
            gun.global_rotation, target_angle,
            ease(aim_lerp_factor * delta, aim_ease_factor)
        )
