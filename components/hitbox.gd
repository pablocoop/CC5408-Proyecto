class_name Hitbox
extends Area2D

signal damage_dealt(target_position: Vector2)
@export var damage = 1
var direction: Vector2 = Vector2.ZERO  # Dirección del golpe, opcional


func _ready():
	monitoring = true
	area_entered.connect(func(area): print("¡Algo entró a mi hitbox!", area))
	

func get_direction() -> Vector2:
	return direction
