class_name StarChunk
extends Node2D


var chunk_coords := Vector2i.ZERO


func setup(base: Stars, coords: Vector2i):
    #print("make chunk at ", coords)
    chunk_coords = coords
    base.rng.seed = hash(chunk_coords)

    global_position = chunk_coords * base.chunk_size

    for _i in base.star_density:
        var sprite = Sprite2D.new()
        sprite.texture = base.stars[base.rng.randi() % base.stars.size()]
        var size = lerpf(base.min_scale, base.max_scale, base.rng.randf())
        sprite.scale = Vector2(size, size)
        sprite.position.x = base.rng.randf() * base.chunk_size
        sprite.position.y = base.rng.randf() * base.chunk_size
        add_child(sprite)
