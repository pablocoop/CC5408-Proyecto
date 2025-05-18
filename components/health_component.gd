class_name HealthComponent
extends Node

signal died
signal health_changed(value)

@export var health: float = 10:
	set(value):
		health = clamp(value,0,max_health)
		health_changed.emit(health)
		
@export var max_health: float = 10


func take_damage(damage:float) -> void:
	health -= damage
