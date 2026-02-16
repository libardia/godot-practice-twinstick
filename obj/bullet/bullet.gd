class_name Bullet
extends Area2D


@export var hit_force: float
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


func _on_collide(node: Node2D) -> void:
    if not collided_this_frame:
        collided_this_frame = true
        var health := HealthComponent.get_from(node)
        if health:
            health.damage(power)
        if node is RigidBody2D:
            node.apply_impulse(
                velocity.normalized() * hit_force,
                global_position - node.global_position
            )
        queue_free()
