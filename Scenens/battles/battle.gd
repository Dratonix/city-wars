extends Node2D

@export var char_stats : CharacterStats

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler : PlayerHandler = $PlayerHandler as PlayerHandler
@onready var player : Player = $Player as Player

func _ready() -> void:
	#normally we would do this on a 'run'
	#level so we keep our health
	#between battles
	var new_stats : CharacterStats = char_stats.create_instance()
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(player_handler.start_turn)
	battle_ui.char_stats =new_stats
	player.stats = new_stats
	start_battle(new_stats) 
	
func start_battle(stats : CharacterStats) -> void:
	player_handler.start_battle(stats)


func _on_card_spawn_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
