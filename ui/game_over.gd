extends Control

@onready var gameover: AudioStreamPlayer = $gameover

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(6).timeout  # Muestra GAME OVER 2.5s
	gameover.play()
	get_tree().change_scene_to_file("res://ui/main_menu.tscn") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# volver a dejar al player en la posición inicial!!!
	#En mi hito 0 yo hacia esto:
	#if Game.current_player and Game.current_player.is_inside_tree():
	#	global_position = Game.current_player.global_position
	pass
