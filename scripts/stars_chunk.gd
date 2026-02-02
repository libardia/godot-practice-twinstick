class_name StarChunk
extends Node2D


var rng := RandomNumberGenerator.new()
var chunk_coords := Vector2i.ZERO


func setup(base: Stars, coords: Vector2i):
    chunk_coords = coords
    rng.seed = hash(chunk_coords)

    position = chunk_coords * base.chunk_size

    if base.debug:
        var rec = ReferenceRect.new()
        rec.editor_only = false
        rec.size = Vector2.ONE * base.chunk_size
        add_child(rec)

    for _i in base.star_density:
        var sprite = Sprite2D.new()
        sprite.texture = base.stars_textures[rng.randi() % base.stars_textures.size()]
        sprite.modulate = base.stars_modulate
        var size = lerpf(base.stars_min_scale, base.stars_max_scale, rng.randf())
        sprite.scale = Vector2(size, size)
        sprite.position.x = rng.randf() * base.chunk_size
        sprite.position.y = rng.randf() * base.chunk_size
        add_child(sprite)
