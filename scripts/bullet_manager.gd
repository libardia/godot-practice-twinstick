extends Node


var bullet_container: Node2D


func fire(scene: PackedScene, init_xform: Transform2D, velocity: Vector2):
    if not bullet_container:
        bullet_container = Node2D.new()
        bullet_container.z_index = -1
        get_tree().current_scene.add_child(bullet_container)
    var bullet: Bullet = scene.instantiate()
    bullet.velocity = velocity
    bullet.global_transform = init_xform
    bullet.visible = false
    bullet_container.add_child(bullet)
