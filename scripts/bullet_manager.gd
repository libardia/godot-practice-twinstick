extends Node


var bullet_container: Node2D


func fire(scene: PackedScene, init_xform: Transform2D, velocity: Vector2):
    if not bullet_container:
        bullet_container = Node2D.new()
        bullet_container.z_index = -1
        get_tree().current_scene.add_child(bullet_container)
        get_tree().current_scene.move_child(bullet_container, 0)
    var bullet: Bullet = scene.instantiate()
    bullet.velocity = velocity
    bullet.global_transform = init_xform
    bullet_container.add_child(bullet)
