extends Node


func absolute_z(target: Node2D) -> int:
    var node = target
    var z_index = 0
    while node and node is Node2D:
        z_index += node.z_index
        if not node.z_as_relative:
            break
        node = node.get_parent()
    return z_index
