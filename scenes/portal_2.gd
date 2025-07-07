extends Area2D

var ready_portal := 0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var current = area
	while current:
		if current.has_method("_attack") and ready_portal:
			print("🎯 ¡Encontrado nodo con método _attack!", current)
			_on_player_entered()
			break
		current = current.get_parent()
			

func _on_player_entered() -> void:
	get_tree().change_scene_to_file("res://ui/credits.tscn")
