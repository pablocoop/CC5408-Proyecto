class_name Hurtbox
extends Area2D

@export var health_component: HealthComponent	

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox and health_component and owner.has_method("take_damage"):
		var from_direction = owner.global_position - hitbox.global_position
		health_component.take_damage(hitbox.damage,from_direction)
		hitbox.damage_dealt.emit(owner.global_position)
	
