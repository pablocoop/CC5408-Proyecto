extends Area2D

@onready var wall_node: Node2D = $".."

var ball_entered := false
var player_entered := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if player_entered and !ball_entered:
		player_entered = false
	elif body is Ball:
		print("Ball tocó la pared")
		ball_entered = true
	elif body is Player:
		print("Player tocó la pared")
		player_entered = true
		

	if ball_entered and player_entered:
		_activar_pared()

func _activar_pared():
	wall_node.show()
	wall_node.get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", false)
