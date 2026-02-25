extends UIResourceBar


func _ready() -> void:
    await GlobalData.player.ready
    tracking = GlobalData.player.health
