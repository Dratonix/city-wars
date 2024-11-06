extends CardState

var played : bool
var a : Vector2

signal is_played(position : Vector2, scene : PackedScene )
func enter() -> void:
	

	
	played = false
	
	
	#Comment out previous line
	if not card_ui.targets.is_empty():
		Events.tooltip_hide_requested.emit()
		played = true
		card_ui.play()

func on_input(_event : InputEvent) -> void:

	if played:
		emit_signal("is_played",Events.pos)
		#get_tree().add_child(scene_instance)
		### Create code for putting a summon at the position of the grid
		return
	
	transition_requested.emit(self, CardState.State.BASE)



func _on_enemy_detector_area_entered(area: Area2D) -> void:
	a = area.position
