extends CharacterBody2D


@export var summon : Summon : set = _set_summon

@export var moves : int = 15
@export var attack : int
@export var defense : int

@onready var sprite : Sprite2D = $Sprite

##Movement
var input_dir
const tile_size = 24
var moving = false

func _physics_process(delta: float) -> void:
	input_dir = Vector2.ZERO
	if Input.is_action_just_pressed("ui_right"):
		input_dir = Vector2(1,0)
		move()
	elif Input.is_action_just_pressed("ui_left"):
		input_dir = Vector2(-1,0)
		move()
	if Input.is_action_just_pressed("ui_down"):
		input_dir = Vector2(0,1)
		move()
	elif Input.is_action_just_pressed("ui_up"):
		input_dir = Vector2(0,-1)
		move()
	move_and_slide()

func move() -> void:
	if input_dir and not moves <= 0:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + input_dir*tile_size, .25)
			tween.tween_callback(move_false)
			moves-=1
func move_false(): 
	moving = false
	
func _set_summon(value : Summon):
	summon = value
	moves = summon.movability
	attack = summon.attack
	defense = summon.defense
	sprite.texture = summon.icon
	


func _on_enemy_detector_area_entered(area: Area2D) -> void:
	if area.get_parent().attack > defense:
		queue_free() 
