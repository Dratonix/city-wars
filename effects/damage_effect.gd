class_name DamageEffect
extends Node

var amount := 0

func execute(targets : Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.take_damage(amount)
