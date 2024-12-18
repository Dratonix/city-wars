extends Node



#Card related events
signal card_drag_started(card_ui : CardUI)
signal card_drag_ended(card_ui : CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card : Card)
signal card_tooltip_requested(card : Card)
signal tooltip_hide_requested
#player related events
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended

#Summoning signals
signal summon_character

#static variables
var pos : Vector2
var char_type : Summon

var select : bool = true

#Turn swapping
enum Turns
{
	player_red,
	player_blue,
	player_green,
	player_yellow
}
var current_turn = Turns.player_red
signal turn_changed
