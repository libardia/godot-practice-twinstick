extends Node2D


func _ready() -> void:
    if randi_range(0,1):
        print("true")
    else:
        print("false")
