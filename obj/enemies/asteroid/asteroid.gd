class_name Asteroid
extends RigidBody2D


enum Type { BROWN, GRAY }

const GROUP_ASTEROIDS := &"asteroids"

static var instances: Dictionary = {
    Type.BROWN: {
        0: RandomResource.with(preload("uid://pjcwr2d4m5to"), preload("uid://cno1ylvvj355e")),
        1: RandomResource.with(preload("uid://btw3dpou2sq25"), preload("uid://00nfd3k7m5wd")),
        2: RandomResource.with(preload("uid://dd3ldgf6yn87g"), preload("uid://dexe42awfoa1g")),
        3: RandomResource.with(preload("uid://c61by5jcptx6n"), preload("uid://cv1idgy47h60t"), preload("uid://bplwcrg2x8n1t"), preload("uid://baej8gojx5qnf")),
    },
    Type.GRAY: {
        0: RandomResource.with(preload("uid://36ud88uu1mpm"), preload("uid://ipxaf4aednip")),
        1: RandomResource.with(preload("uid://1gnsbdhh8rsn"), preload("uid://cposljxlck1st")),
        2: RandomResource.with(preload("uid://b2umqi03q8wrp"), preload("uid://bsfn33p8jihxx")),
        3: RandomResource.with(preload("uid://d3ohyf4q5fmrg"), preload("uid://dv23voiwoyxvm"), preload("uid://wto1p1utdjk4"), preload("uid://dmmykmglqgsej")),
    },
}

@export var size: int
@export var type: Type
@export_group("Initial State on Splitting", "split_")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var split_min_speed: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var split_max_speed: float
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var split_min_angular: float
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var split_max_angular: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var split_separation: float

@onready var health: ResourceComponent = %HealthComponent


func _enter_tree() -> void:
    mass *= pow(2, size)


func _ready() -> void:
    health.max_value *= 2 ** size
    health.current = health.max_value
    health.depleted.connect(die)


func die() -> void:
    if size > 0:
        var rand: RandomResource = instances[type][size-1]
        var dir := linear_velocity.normalized().orthogonal()
        var ast1 := make_part(rand.choose(), dir)
        get_parent().add_child.call_deferred(ast1)
        var ast2 := make_part(rand.choose(), -dir)
        get_parent().add_child.call_deferred(ast2)
        ast1.add_collision_exception_with(ast2)
        if is_in_group(AsteroidSpawner.GROUP_SPAWNED_ASTEROID):
            ast1.add_to_group.call_deferred(AsteroidSpawner.GROUP_SPAWNED_ASTEROID)
    queue_free()


func make_part(scene: PackedScene, dir: Vector2) -> Asteroid:
    var ast: Asteroid = scene.instantiate()

    # Set initial velocity
    ast.linear_velocity = linear_velocity
    ast.linear_velocity += dir * randf_range(split_min_speed, split_max_speed)

    # Set initial angular velocity
    var split_ang_dir := [1, -1].pick_random() as float
    ast.angular_velocity = split_ang_dir * randf_range(split_min_angular, split_max_angular)

    # Starting position
    ast.global_position = global_position + dir * split_separation

    return ast
