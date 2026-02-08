class_name AsteroidSpawner
extends Node2D


@export_group("Spawn Settings")
@export var spawns: RandomResource
@export var chunk_size: float
@export_group("Initial State", "init_")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var init_speed_min: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var init_speed_max: float
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var init_angular_min: float
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var init_angular_max: float

var _generated := Set.new()


func _physics_process(_delta: float) -> void:
    pass


func spawn(at: Vector2):
    var ast: Asteroid = (spawns.choose() as PackedScene).instantiate()
    ast.global_position = at

    # Random initial velocity
    var lin = Vector2.RIGHT * randf_range(init_speed_min, init_speed_max)
    ast.linear_velocity = lin.rotated(TAU * randf())

    # Random inital angular velocity
    var ang = randf_range(init_angular_min, init_angular_max)
    ast.angular_velocity = deg_to_rad(ang) * [-1, 1].pick_random()

    add_child(ast)
