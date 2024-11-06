extends Node


var scene : PackedScene

@onready var released := get_node("%ReleasedState")

func _ready() -> void:
	#+released.connect("is_played", Callable(self,"played"))
	pass
