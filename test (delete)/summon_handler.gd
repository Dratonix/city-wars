extends Node2D

@onready var collision1 = $cardSpawn/CollisionShape2D
@onready var m1 = $RedPlayerSummons


var link = preload("res://Summons/summon.tscn")
var children = get_children()

func _ready() -> void:
	Events.summon_character.connect(_summon_char)
func _summon_char() -> void:
	children = get_children()

	var instance = link.instantiate()
	instance.summon = Events.char_type
	instance.position = Events.pos
	#children[Events.current_turn].add_child(instance)
	add_child(instance)
