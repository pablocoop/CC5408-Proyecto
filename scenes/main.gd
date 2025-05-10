extends Node2D

@onready var ball: RigidBody2D = $Ball

var current_time_scale := 1.0
var target_time_scale := 1.0
@export var smooth_transition_speed := 5.0


func _ready():
	ball.ball_stopped.connect(_on_ball_stopped)
	ball.ball_relaunched.connect(_on_ball_relaunched)
	ball.ball_speed_changed.connect(_on_ball_speed_changed)  # Nueva conexión

	_on_ball_stopped()  # Estado inicial

func _process(delta: float) -> void:
	current_time_scale = lerp(current_time_scale, target_time_scale, delta * smooth_transition_speed)
	Engine.time_scale = current_time_scale

func _on_ball_stopped():
	Debug.log("ball stopped")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.pause_enemy()

func _on_ball_relaunched():
	Debug.log("ball relaunched")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.resume_enemy()

func _on_ball_speed_changed(factor: float) -> void:
	target_time_scale = factor
