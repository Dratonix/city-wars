extends Node2D

const ARC_POINTS := 8

@onready var area_2d : Area2D = $Area2D
@onready var card_arc: Line2D = $CanvasLayer/CardArc

var current_card: CardUI
var targeting := false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_aim_started)
	Events.card_aim_ended.connect(_on_card_aim_ended)
	
func _process(delta: float) -> void:
	if not targeting:
		return
	area_2d.position = get_local_mouse_position()
	card_arc.points = _get_points()

func _get_points() -> Array:
	var points := []
	var start := current_card.global_position
	start.x += (current_card.size.x /2)
	var target := get_local_mouse_position()
	var distance := (target -start) 
	for i in range(ARC_POINTS):
		var t := (1.0/ARC_POINTS) * i
		var x := start.x + (distance.x/ARC_POINTS) * i
		var y := start.y + ease_out_cubic(t) * distance.y
		points.append(Vector2(x,y))
	return points
	
func ease_out_cubic(number : float) -> float:
	return 1 - pow(1.0-number, 3.0)

func _on_card_aim_started(card : CardUI) -> void:
	if not card.card.is_single_targeted():
		return
		
	targeting = true
	area_2d.monitoring = true
	area_2d.monitorable = true
	current_card = card
func _on_card_aim_ended(_card : CardUI) -> void:
	targeting = false
	card_arc.clear_points()
	area_2d.position = Vector2.ZERO
	area_2d.monitorable=false
	area_2d.monitoring=false
	current_card=null
	
func _on_area_2d_area_entered(area : Area2D) -> void:
	var run = false
	if not current_card or not targeting:
		return
	if "Spawn" in area.name or "Area" in area.name :
		print(area.is_in_group('r_tile') and Events.current_turn == Events.Turns.player_red)
		print(area.get_groups())
		if  area.is_in_group('r_tile') and Events.current_turn==Events.Turns.player_red:
					Events.pos=area.position-position
					print('play')
					run=true
		elif Events.current_turn == Events.Turns.player_blue and area.is_in_group( 'b_tile'):
			Events.pos=area.position-position
			run=true
			
		elif Events.current_turn == Events.Turns.player_green and area.is_in_group('g_tile'):
			Events.pos=area.position-position
			run=true
		elif Events.current_turn == Events.Turns.player_yellow and area.is_in_group( 'y_tile'):
			Events.pos=area.position-position
			run=true
		if run and not current_card.targets.has(area):
			
			current_card.targets.append(area)

		
func _on_area_2d_area_exited(area : Area2D) -> void:
	Events.pos=area.position-position
	if not current_card or not targeting:
		return
	current_card.targets.erase(area)
