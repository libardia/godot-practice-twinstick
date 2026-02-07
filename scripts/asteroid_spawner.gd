class_name AsteroidSpawner
extends Node2D


@export_group("Spawn Settings")
@export var spawns: RandomResource
@export_group("Initial State", "init_")
@export var init_speed_min: float
@export var init_speed_max: float
@export var init_angular_min: float
@export var init_angular_max: float


func _ready() -> void:
    spawn(Vector2.ONE * 100)


func spawn(at: Vector2):
    var ast: Asteroid = (spawns.choose() as PackedScene).instantiate()
    ast.global_position = at

    # Random initial velocity
    var lin = Vector2.RIGHT * lerpf(init_speed_min, init_speed_max, randf())
    ast.linear_velocity = lin.rotated(TAU * randf())

    # Random inital angular velocity
    var ang = lerpf(init_angular_min, init_angular_max, randf())
    ast.angular_velocity = ang * [-1, 1].pick_random()

    add_child(ast)
