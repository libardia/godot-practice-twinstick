extends Node


@export var cursor: Texture2D
@export var hotspot: Vector2
@export var mkb_cursor_mode: Input.MouseMode
@export var controller_cursor_mode: Input.MouseMode

var cursor_img: Image


func _ready() -> void:
    cursor_img = cursor.get_image()
    InputDetector.source_changed.connect(on_source_changed)


func on_source_changed():
    if InputDetector.is_mkb():
        Input.set_custom_mouse_cursor(cursor_img, Input.CURSOR_ARROW, hotspot)
        Input.mouse_mode = mkb_cursor_mode
    else:
        Input.set_custom_mouse_cursor(null)
        Input.mouse_mode = controller_cursor_mode
