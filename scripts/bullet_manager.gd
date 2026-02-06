extends Node


var bullet_container: Node2D


func fire(scene: PackedScene, init_xform: Transform2D, velocity: Vector2, z_index: int = 0):
    if not bullet_container:
        bullet_container = Node2D.new()
        get_tree().current_scene.add_child(bullet_container)
    var bullet: Bullet = scene.instantiate()
    bullet.velocity = velocity
    bullet.global_transform = init_xform
    bullet.z_index = z_index
    bullet.z_as_relative = false
    bullet_container.add_child(bullet)
