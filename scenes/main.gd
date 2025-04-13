extends Node2D

@onready var ball: RigidBody2D = $Ball


func _ready():
	ball.ball_stopped.connect(_on_ball_stopped)
	ball.ball_relaunched.connect(_on_ball_relaunched)
	_on_ball_stopped()

func _on_ball_stopped():
	Debug.log("ball stopped")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.pause_enemy()

func _on_ball_relaunched():
	Debug.log("ball relaunched")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.resume_enemy()
