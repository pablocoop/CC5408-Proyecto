class_name Hitbox
extends Area2D

signal damage_dealt(target_position: Vector2)
@export var damage = 1

func _ready():
	area_entered.connect(func(area): print("¡Algo entró a mi hitbox!", area))
