class_name CardState
extends Node

enum State{BASE, CLICKED, DRAGGIN, AIMING, RELEASED}

signal transition_requested(from : CardState, to :State)
signal card_ended(position : Vector2)
@export var state : State

var card_ui : CardUI

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass

func on_input(_event: InputEvent):
	pass

func on_gui_input(_event: InputEvent):
	pass
