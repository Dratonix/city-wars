class_name CardUI
extends Control 

signal reparent_requested(whic_card_ui : CardUI)


const BASE_STYLEBOX := preload("res://Scenens/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX :=preload("res://Scenens/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://Scenens/card_ui/card_hover_stylebox.tres")


@export var card: Card : set = _set_card
@export var char_stats : CharacterStats : set = _set_char_stats
@export var summon_stats : Summon


@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var card_state_machine : CardStateMachine = $CardStateMachine as CardStateMachine
@onready var drop_point_detector : Area2D = $DropPointDetector
@onready var coll : CollisionShape2D = $DropPointDetector/CollisionShape2D
@onready var targets: Array[Node] = []
@onready var released := get_node("%ReleasedState")
@onready var original_index := self.get_index()

var parent : Control
var tween : Tween
var scene_position : Vector2
var scene : PackedScene
var playable := true : set = _set_playable
var disabled := false


func _ready() -> void:

	card_state_machine.init(self)
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	released.connect("is_played", Callable(self,"played"))

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func play() -> void:
	if not card:
		return
	card.play(targets, char_stats)
	queue_free()
func animate_to_position(new_position: Vector2, duration : float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)


func _on_released_state_card_ended() -> void:
	pass # Replace with function body.
func played(a : Vector2 ) -> void:
	if scene == null:
		return
	var scene_instance = scene.instantiate()
	
	print(Events.pos)

	
	scene_instance.position = Vector2(Events.pos.x - position.x, Events.pos.y - position.y)
	add_child(scene_instance)
	scene = null
func _set_card(value : Card):
	if not is_node_ready():
		await ready
	card = value
	cost.text = str(card.cost)
	icon.texture=card.icon
	scene = card.summon

func _set_playable(value : bool) -> void:
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1,1,1,.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate= Color(1,1,1,1)
func _set_char_stats(value : CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)
func _on_card_drag_or_aiming_started(used_card : CardUI) -> void:
	if used_card == self:
		return
	disabled = true

func _on_card_drag_or_aim_ended(_card : CardUI) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)

func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)
