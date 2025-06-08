extends Node2D


func _ready() -> void:
	await get_tree().create_timer(2.5).timeout 
	#Game.life = 7  # Reinicia las vidas
	get_tree().change_scene_to_file("res://ui/main_menu.tscn") 


func _process(delta: float) -> void:
	# volver a dejar al player en la posición inicial!!!
	#En mi hito 0 yo hacia esto:
	#if Game.current_player and Game.current_player.is_inside_tree():
	#	global_position = Game.current_player.global_position
	pass
