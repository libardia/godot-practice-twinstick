class_name Bullet
extends Area2D


var velocity: Vector2


func _physics_process(delta: float) -> void:
    visible = true
    position += velocity * delta
