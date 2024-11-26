extends Node

@onready var collision1 = $cardSpawn/CollisionShape2D

var link = preload("res://Summons/summon.tscn")

func _ready() -> void:
	Events.summon_character.connect(_summon_char)
	
func _summon_char() -> void:
	var instance = link.instantiate()
	instance.summon = Events.char_type
	instance.position = Events.pos
	add_child(instance)
	print("gyatt")
