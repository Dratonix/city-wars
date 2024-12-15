extends CharacterBody2D

@export var summon : Summon : set = _set_summon

@export var moves : int = 15
@export var attack : int
@export var defense : int
@export var team : int

@export var tiles : TileSet

@onready var sprite : Sprite2D = $Sprite
@onready var click_area : CollisionShape2D = $ClickDetector/CollisionShape2D
@onready var enemy_detector : Area2D = $EnemyDetector

## Movement and control variables
var input_dir
const tile_size = 24
var moving = false
var click = false  # Track whether the character has been clicked
var can_move = false  # Only allow movement if clicked


func _ready() -> void:
##	position=Vector2.ZERO
	team = Events.current_turn
	Events.connect("turn_changed", _reset)
	match Events.current_turn:
		Events.Turns.player_red:
			add_to_group("red")
			enemy_detector.add_to_group("red")
			return
		Events.Turns.player_blue:
			add_to_group("blue")
			enemy_detector.add_to_group("blue")
			return
		Events.Turns.player_green:
			add_to_group("green")
			enemy_detector.add_to_group("green")
			return
		Events.Turns.player_yellow:
			add_to_group("yellow")
			enemy_detector.add_to_group("yellow")
			return
		
func _process(delta: float) -> void:
	# Only allow click_area to be interactable if it's the selected character
	if Events.select or Events.current_turn == team:
		click_area.disabled = false
	else:
		click_area.disabled = true
		

	# Handle right mouse click
	if Input.is_action_just_pressed("right_mouse"):
		click_area.disabled = false
		Events.select = true
		click = false  # Reset click status
		can_move = false  # Disable movement until click is detected
	
func _physics_process(delta: float) -> void:
	if not can_move:
		return  # Don't process movement if the character can't move
	
	input_dir = Vector2.ZERO

	# Handle movement input
	if Input.is_action_just_pressed("ui_right"):
		input_dir = Vector2(1, 0)
	elif Input.is_action_just_pressed("ui_left"):
		input_dir = Vector2(-1, 0)
	elif Input.is_action_just_pressed("ui_down"):
		input_dir = Vector2(0, 1)
	elif Input.is_action_just_pressed("ui_up"):
		input_dir = Vector2(0, -1)

	# Move the character if input direction is valid
	if input_dir != Vector2.ZERO and not moves <= 0 and click:
		move(input_dir)
		moves -= 1

func move(input_dir: Vector2) -> void:
	if moving == false and Events.current_turn == team:
		moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + input_dir * tile_size, 0.25)
		tween.tween_callback(move_false)  # Call move_false after movement is done

func move_false(): 
	moving = false

# This function is called when a summon is set
func _set_summon(value : Summon):
	if not is_node_ready():
		await ready
	summon = value
	moves = summon.movability
	attack = summon.attack
	defense = summon.defense
	sprite.texture = summon.icon

# Handle the click event for selecting the character
func _on_click_detector_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			click = true  # The character is now selected and ready to move
			Events.select = false  # Deselect this character for other actions
			can_move = true  # Allow movement after being clicked
			print("Character clicked")

func _reset() -> void:
	moves = summon.movability

func _on_enemy_detector_area_entered(area: Area2D) -> void:
	if area.get_groups() != enemy_detector.get_groups():
		print(attack > area.get_parent().attack)
