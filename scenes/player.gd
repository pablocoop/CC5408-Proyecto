class_name Player
extends CharacterBody2D

signal proximity_entered(ball)
signal proximity_exited(ball)

@onready var proximity_check: Area2D = $ProximityCheck

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
	proximity_check.area_entered.connect(_on_area_entered)
	proximity_check.area_exited.connect(_on_area_exited)
	proximity_entered.connect(func(ball): ball.set_player_nearby(true))
	proximity_exited.connect(func(ball): ball.set_player_nearby(false))
	
func _on_area_entered(area: Area2D) -> void:
	var ball = area.get_parent() as Ball
	if ball and ball.has_method("set_player_nearby"):
		proximity_entered.emit(ball)

func _on_area_exited(area: Area2D) -> void:
	var ball = area.get_parent() as Ball
	if ball and ball.has_method("set_player_nearby"):
		proximity_exited.emit(ball)

func _process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale
	animation_tree.advance(real_delta)
	
func _physics_process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	is_running = Input.is_action_pressed("run")
	
	var current_speed = speed * run_multiplier if is_running else speed
	var direction = input.normalized()
	velocity = direction * current_speed * real_delta / delta  # Compensar el slowdown
	
	move_and_slide()
	_select_animation()
	_update_animation_parameters()


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
