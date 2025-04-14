extends CharacterBody2D


@export var speed = 400
@export var acceleration = 900
@export var max_health := 10
var current_health := max_health
var is_running := false
@export var run_multiplier := 1.5

var input: Vector2
var playback: AnimationNodeStateMachinePlayback

@export var animation_tree: AnimationTree



func _ready() -> void:
	playback = animation_tree["parameters/playback"]

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	is_running = Input.is_action_pressed("run")
	
	var current_speed = speed * run_multiplier if is_running else speed
	velocity = input * current_speed
	
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
	elif is_running:
		playback.travel("running")	
	else:
		playback.travel("walking")
	
func _update_animation_parameters() -> void:
	if input == Vector2.ZERO:
		return
	animation_tree["parameters/idle/blend_position"] = input
	animation_tree["parameters/walking/blend_position"] = input
	animation_tree["parameters/running/blend_position"] = input

func _input(event: InputEvent) -> void:
	pass
