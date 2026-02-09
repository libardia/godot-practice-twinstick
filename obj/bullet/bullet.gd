class_name Bullet
extends Area2D


@export var power: float

var velocity: Vector2


func _physics_process(delta: float) -> void:
    visible = true
    position += velocity * delta


func _on_collide(node: Node2D):
    if node.is_in_group(HealthComponent.GROUP_HAS_COMPONENT):
        node.health_component.damage(power)
    queue_free()
