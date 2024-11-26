extends CardState

var played : bool
var a : Vector2

func enter() -> void:
	

	print("sigma")
	played = false
	
	
	#Comment out previous line
	if not card_ui.targets.is_empty():
		Events.tooltip_hide_requested.emit()
		played = true
		print("played ")
		Events.char_type = card_ui.summon_stats
		Events.emit_signal("summon_character")
		card_ui.play()

func on_input(_event : InputEvent) -> void:

	if played:
		print("played ")

		#get_tree().add_child(scene_instance)
		### Create code for putting a summon at the position of the grid
		return
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	transition_requested.emit(self, CardState.State.BASE)



func _on_enemy_detector_area_entered(area: Area2D) -> void:
	a = area.position
