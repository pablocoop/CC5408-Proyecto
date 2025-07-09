extends Node2D

@onready var ball: RigidBody2D = $Ball

var current_time_scale := 1.0
var target_time_scale := 1.0
@export var smooth_transition_speed := 5.0
@onready var wall_level: Node2D = $WallLevel1
@onready var wall_level_2: Node2D = $WallLevel2
@onready var wall_level_3: Node2D = $WallLevel3
@onready var wall_level_4: Node2D = $WallLevel4
@onready var portal_1: Area2D = $Portal2

var enemy_count := 0
@onready var music_level_1: AudioStreamPlayer = $music_level1
@onready var boss_area: Area2D = $BossArea


func _ready():
	boss_area.body_entered.connect(_on_boss_area_entered)
	# Busca enemigos al iniciar
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy_count += 1
		enemy.enemy_died.connect(_on_enemy_died)

	# Portal oculto y no activo al inicio
	portal_1.hide()
	portal_1.ready_portal = 0
	wall_level_2.hide()
	wall_level_2.get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", true)

	wall_level_3.hide()
	wall_level_3.get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", true)
		
	ball.ball_stopped.connect(_on_ball_stopped)
	ball.ball_relaunched.connect(_on_ball_relaunched)
	ball.ball_speed_changed.connect(_on_ball_speed_changed)  # Nueva conexión

	_on_ball_stopped()  # Estado inicial

func _process(delta: float) -> void:
	current_time_scale = lerp(current_time_scale, target_time_scale, delta * smooth_transition_speed)
	Engine.time_scale = current_time_scale

func _on_ball_stopped():
	Debug.log("ball stopped")
	if get_tree():
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.pause_enemy()

func _on_ball_relaunched():
	Debug.log("ball relaunched")
	if get_tree():
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.resume_enemy()

func _on_ball_speed_changed(factor: float) -> void:
	target_time_scale = factor
	# (Opcional) Propaga también el factor a los enemigos,
	# en caso de que quieras controlar ellos directamente:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy._on_slowmo_factor(factor)
		
func _on_enemy_died():
	enemy_count -= 1
	print("☠️ Enemigo eliminado. Quedan:", enemy_count)
	if enemy_count == 1:
		wall_level.queue_free()
	if enemy_count == 3:
		wall_level_4.hide()
		wall_level_4.get_node("StaticBody2D/CollisionShape2D").set_deferred("disabled", true)
	if enemy_count == 0:
		portal_1.show()
		portal_1.ready_portal = 1
		
func _on_boss_area_entered(body):
	print("👣 Entró al área:", body)
	if body.name == "Player":
		print("🎵 Cambiando música")
		var new_stream = load("res://music/xDeviruchi - 8-bit Fantasy  & Adventure Music (2021)/xDeviruchi - Prepare for Battle! .wav")
		if new_stream:
			music_level_1.stream = new_stream
			music_level_1.volume_db = -18
			music_level_1.play()
		else:
			print("⚠️ No se pudo cargar la música")
		
