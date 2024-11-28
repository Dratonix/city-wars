extends Area2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D



func _on_body_entered(area: Node2D) -> void:
	if "Summon" in area.name or "Character" in area.name:
		collision_layer = 0

func _on_body_exited(area: Node2D) -> void:
	if "Summon" in area.name or "Character" in area.name:
		collision_mask = 4
