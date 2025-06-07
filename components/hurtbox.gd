class_name Hurtbox
extends Area2D

@export var health_component: HealthComponent	

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	print("✅ Entró un área: ", area.name)
	var hitbox = area as Hitbox
	var parent_node = self
	while parent_node and not parent_node.has_method("take_damage"):
		parent_node = parent_node.get_parent()

	if hitbox and health_component and parent_node.has_method("take_damage"):
		
		# Si el dueño de esta hurtbox es un enemigo...
		if parent_node.is_in_group("enemies"):
			# ...solo aceptar daño si el atacante es la pelota
			if not hitbox.get_parent().is_in_group("ball"):
				print("❌ Ataque ignorado: no viene de la pelota")
				return  # Cancelar si no es la pelota

		print("🎯 Hurtbox detectó hitbox:", hitbox)
		var from_direction: Vector2
		# Determinar dirección desde el atacante (hitbox) hacia el objetivo (hurtbox/parent_node)
		if hitbox.has_method("get_direction"):
			from_direction = hitbox.get_direction().normalized()
		else:
			from_direction = (parent_node.global_position - hitbox.global_position).normalized()

		# Validar que no sea un vector nulo
		if from_direction.length_squared() < 0.01:
			# Usar la posición del atacante contra el objetivo como fallback
			from_direction = (hitbox.get_parent().global_position - parent_node.global_position).normalized()

			# Si aún así está mal, fallback final
			if from_direction.length_squared() < 0.01:
				from_direction = Vector2.RIGHT  # Solo como último recurso

		parent_node.take_damage(hitbox.damage, from_direction)
		hitbox.damage_dealt.emit(parent_node.global_position)
	
