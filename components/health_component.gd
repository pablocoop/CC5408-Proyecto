class_name HealthComponent
extends Node

signal died
signal health_changed(value)

@export var health: float = 10:
	set(value):
		if health == value:
			return
		health = clamp(value,0,max_health)
		health_changed.emit(health)
		if health == 0:
			died.emit()
@export var max_health: float = 10


func take_damage(damage:float,from_direction: Vector2) -> void:
	health -= damage
	if owner.has_method("flash_red") and owner.has_method("start_invulnerability"):
		owner.start_invulnerability()
		owner.flash_red()
