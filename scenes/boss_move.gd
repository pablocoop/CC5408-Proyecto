extends Area2D

var ball_entered := false
var player_entered := false
@onready var boss: CharacterBody2D = $"../Boss"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if player_entered and !ball_entered:
		player_entered = false
	elif body is Ball:
		ball_entered = true
	elif body is Player:
		player_entered = true
		

	if ball_entered and player_entered:
		boss.start_moving()
		queue_free()
