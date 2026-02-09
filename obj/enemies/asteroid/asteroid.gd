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
        0: RandomResource.with(preload("uid://okhev8dn1pgk"), preload("uid://cwqivny4go2tp")),
        1: RandomResource.with(preload("uid://dslsfuadjq5yp"), preload("uid://bwscdgi62eda2")),
        2: RandomResource.with(preload("uid://do2retkpq5vme"), preload("uid://bvhiqxrb4j50v")),
        3: RandomResource.with(preload("uid://bo4jdm4brvaaf"), preload("uid://cnxc4mlp75r2f"), preload("uid://btgwhlyo45rlm"), preload("uid://b1bg4bunqhumj")),
    },
}

@export var size: int
@export var base_mass: float = 1
@export var type: Type

@onready var health_component: HealthComponent = %HealthComponent


func _enter_tree() -> void:
    add_to_group(GROUP_ASTEROIDS)
    mass = base_mass * pow(2, size)


func die() -> void:
    if size > 0:
        var rand: RandomResource = instances[type][size-1]
        var ast1: Asteroid = rand.choose().instantiate()
        var ast2: Asteroid = rand.choose().instantiate()
        ast1.global_position = global_position
        ast2.global_position = global_position
        get_parent().add_child.call_deferred(ast1)
        get_parent().add_child.call_deferred(ast2)
        if is_in_group(AsteroidSpawner.GROUP_SPAWNED_ASTEROID):
            ast1.add_to_group.call_deferred(AsteroidSpawner.GROUP_SPAWNED_ASTEROID)
    queue_free()
