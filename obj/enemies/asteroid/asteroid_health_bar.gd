extends HealthBar


@export var offset: Vector2

@onready var collision_polygon_2d: CollisionPolygon2D = %CollisionPolygon2D


func _ready() -> void:
    var bounds := PolygonUtil.polygon_bounds(collision_polygon_2d.polygon)
    bounds.position += collision_polygon_2d.position

    # Position is relative to the bounds
    position = bounds.position
    # Move over to the middle of the bounds rect
    position.x += bounds.size.x / 2
    # Center horizontally, but move an entire height up
    position -= Vector2(size.x / 2, size.y)
    # User-defined additional offset
    position += offset

    # Call the base ready()
    super._ready()
