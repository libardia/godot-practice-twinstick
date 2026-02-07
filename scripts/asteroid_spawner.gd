class_name AsteroidSpawner
extends Node2D


@export var spawns: RandomResource


func spawn(at: Vector2):
    var ast: Asteroid = (spawns.choose() as PackedScene).instantiate()
    ast.global_position = at
    add_child(ast)
