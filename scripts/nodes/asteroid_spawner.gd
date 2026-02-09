class_name AsteroidSpawner
extends Node2D


@export_group("Spawn Settings")
@export var spawns: RandomResource
@export_custom(PROPERTY_HINT_NONE, "suffix:hz") var frequency: float
@export_custom(PROPERTY_HINT_NONE, "suffix:obj/Mpx²") var spawn_density: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var spawn_radius: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var despawn_buffer: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var screen_buffer: float
@export_group("Initial State", "init_")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var init_speed_min: float
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var init_speed_max: float
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var init_angular_min: float
@export_custom(PROPERTY_HINT_NONE, "suffix:°/s") var init_angular_max: float


func _enter_tree() -> void:
    var timer = Timer.new()
    timer.wait_time = 1.0 / frequency
    timer.autostart = true
    timer.timeout.connect(spawn_tick)
    add_child(timer)


func spawn_tick():
    var hvp = get_viewport_rect().size / 2
    var inner = max(hvp.x, hvp.y) + screen_buffer
    var outer = inner + spawn_radius
    var despawn = outer + despawn_buffer
    var total_amount = _calc_spawn_amount(inner, outer)
    var asteroids = get_tree().get_nodes_in_group(Asteroid.GROUP_ASTEROIDS)
    var spawn_amount = total_amount - asteroids.size()
    for ast: Asteroid in asteroids:
        var dist_sq = GlobalData.player.global_position.distance_squared_to(ast.global_position)
        if dist_sq > despawn * despawn:
            ast.queue_free()
            spawn_amount += 1
    for _i in spawn_amount:
        var dist = Vector2.RIGHT * randf_range(inner, outer)
        var pos = dist.rotated(TAU * randf())
        spawn(GlobalData.player.global_position + pos)


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


func _calc_spawn_amount(inner, outer) -> int:
    var outer_area = PI * outer * outer
    var inner_area = PI * inner * inner
    var area = outer_area - inner_area
    return ceili(area * 1e-6 * spawn_density)
