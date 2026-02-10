class_name Bullet
extends Area2D


@export var power: float

var velocity: Vector2
var collided_this_frame: bool = false
var start_disabled: bool = true


func _enter_tree() -> void:
    if start_disabled:
        visible = false
        monitoring = false


func _physics_process(delta: float) -> void:
    if start_disabled:
        start_disabled = false
        visible = true
        monitoring = true
    collided_this_frame = false
    position += velocity * delta


func _on_collide(node: Node2D):
    if not collided_this_frame:
        collided_this_frame = true
        if node.is_in_group(HealthComponent.GROUP_HAS_COMPONENT):
            node.health_component.damage(power)
        queue_free()
