## Generates a random background of stars
class_name Stars
extends Node2D


@export_group("Stars", "stars_")
@export var stars_textures: Array[Texture2D] = []
@export var stars_modulate: Color = Color.WHITE
@export_custom(PROPERTY_HINT_NONE, "suffix:%") var stars_min_scale: float
@export_custom(PROPERTY_HINT_NONE, "suffix:%") var stars_max_scale: float
@export_group("Generation")
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "suffix:px") var chunk_size: float
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "suffix:chunks") var deload_distance: float
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "suffix:stars/chunk") var star_density: int
@export var debug: bool = false

var seen_rect: Rect2
var chunks: Dictionary[Vector2i, StarChunk] = {}
var rng := RandomNumberGenerator.new()


func _process(_delta: float) -> void:
    seen_rect = get_viewport_rect()
    var half_size = seen_rect.size / 2.0

    if get_parent() is Parallax2D:
        # Special handling for parallax
        seen_rect.position = get_parent().screen_offset - get_parent().position
    else:
        var cam = get_viewport().get_camera_2d()
        if cam != null:
            seen_rect.position = cam.get_screen_center_position() - half_size

    var seen_chunks = Rect2i()
    seen_chunks.position = Vector2i((seen_rect.position / chunk_size).floor()) - Vector2i.ONE
    seen_chunks.end = Vector2i((seen_rect.end / chunk_size).ceil()) + Vector2i.ONE

    var seen_center = seen_rect.get_center() / chunk_size

    # abort if the whole seen area is bigger than deload distance
    if max(seen_chunks.size.x, seen_chunks.size.y) > deload_distance:
        return

    # make chunks if necessary
    for cx in range(seen_chunks.position.x, seen_chunks.end.x):
        for cy in range(seen_chunks.position.y, seen_chunks.end.y):
            var chunk_coord = Vector2i(cx, cy)
            if not chunks.has(chunk_coord):
                if debug:
                    print("Stars: make chunk at ", chunk_coord)
                var chunk = StarChunk.new()
                chunk.setup(self, chunk_coord)
                add_child(chunk)
                chunks[chunk_coord] = chunk

    # delete chunks too far away
    for chunk_coord: Vector2i in chunks.keys():
        if seen_center.distance_squared_to(chunk_coord) > deload_distance ** 2:
            if debug:
                print("Stars: destroy chunk at ", chunk_coord)
            var chunk = chunks[chunk_coord]
            chunks.erase(chunk_coord)
            chunk.queue_free()
