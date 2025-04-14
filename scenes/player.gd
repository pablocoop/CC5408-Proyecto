extends CharacterBody2D


@export var speed = 400
@export var acceleration = 900
@export var max_health := 10
var current_health := max_health

var input: Vector2
var playback: AnimationNodeStateMachinePlayback

@export var animation_tree: AnimationTree



func _ready() -> void:
	playback = animation_tree["parameters/playback"]

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
	_select_animation()
	_update_animation_parameters()
	# Movimiento vertical
	#var direction_y := Input.get_axis("move_up", "move_down")
	#if direction_y:
		#velocity.y = direction_y * speed
	#else:
		#velocity.y = move_toward(velocity.y, 0, speed)
		#
	## Movimiento horizontal
	#var direction_x := Input.get_axis("move_left", "move_right")
	#if direction_x:
		#velocity.x = direction_x * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
func _select_animation() -> void:
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	else:
		playback.travel("walking")
	
func _update_animation_parameters() -> void:
	if input == Vector2.ZERO:
		return
	animation_tree["parameters/idle/blend_position"] = input
	animation_tree["parameters/walking/blend_position"] = input

func _input(event: InputEvent) -> void:
	pass
