class_name LogUtil


static func trace(name: String) -> void:
    Log.debug("%s: %s" % [name, get_stack()[1]["function"]])
