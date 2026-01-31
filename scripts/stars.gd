class_name Stars
extends Node2D


@export var stars: Array[Texture2D] = []
@export_custom(PROPERTY_HINT_NONE, "suffix:%") var min_scale := 0.25
@export_custom(PROPERTY_HINT_NONE, "suffix:%") var max_scale := 0.75
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "suffix:px") var chunk_size := 1024.0
@export_custom(PROPERTY_HINT_ARRAY_TYPE, "suffix:chunks") var deload_distance := 10.0
@export var star_density := 40

var rng = RandomNumberGenerator.new()
var seen_rect: Rect2
var chunks: Dictionary[Vector2i, StarChunk] = {}


func _process(_delta: float) -> void:
    var cam = get_viewport().get_camera_2d()
    seen_rect = get_viewport_rect()
    seen_rect.position = cam.global_position - (seen_rect.size / 2.0)

    var seen_chunks = Rect2i(floor(seen_rect.position / chunk_size), ceil(seen_rect.size / chunk_size) + Vector2.ONE)
    var seen_center = seen_rect.get_center() / chunk_size

    # abort if the whole seen area is bigger than deload distance
    if max(seen_chunks.size.x, seen_chunks.size.y) > deload_distance:
        return

    # make chunks if necessary
    for cx in range(seen_chunks.position.x, seen_chunks.end.x):
        for cy in range(seen_chunks.position.y, seen_chunks.end.y):
            var chunk_coord = Vector2i(cx, cy)
            if not chunks.has(chunk_coord):
                var chunk = StarChunk.new()
                chunk.setup(self, chunk_coord)
                add_child(chunk)
                chunks[chunk_coord] = chunk

    # delete chunks too far away
    for chunk_coord: Vector2i in chunks.keys():
        if seen_center.distance_squared_to(chunk_coord) > deload_distance ** 2:
            #print("destroy chunk at ", chunk_coord)
            var chunk = chunks[chunk_coord]
            chunks.erase(chunk_coord)
            chunk.queue_free()
