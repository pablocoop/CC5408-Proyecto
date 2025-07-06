class_name Ball
extends RigidBody2D

signal ball_stopped
signal ball_relaunched
signal ball_speed_changed(slow_motion_factor: float)

@export var max_time_scale := 1.0
@export var min_time_scale := 0.2
@export var speed_threshold := 100.0  # Velocidad a partir de la cual el mundo empieza a ralentizarse

@export var launch_speed = 1500
var was_moving := false
var player_nearby := false

@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var indicator: Node2D = $HitDirectionIndicator
@onready var arrow_sprite: Sprite2D = indicator.get_node("ArrowSprite")

var has_moved := false  # Variable que indica si la pelota ha sido lanzada
var show_duration := 0.6
var show_timer := 0.0


func _ready():
	hitbox.damage_dealt.connect(_on_damage_dealt)
	
	add_to_group("ball")
	linear_damp = 0.8
	arrow_sprite.visible = false
	arrow_sprite.rotation = 0
	# Conectar también el AttackHitbox del jugador
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var p = players[0]
		var atk = p.get_node("AttackHitbox") as Hitbox
		if atk:
			atk.damage_dealt.connect(_on_damage_dealt)
	randomize()
	
func _physics_process(delta: float) -> void:
	if linear_velocity.length() < 15:
		if was_moving:
			was_moving = false
			ball_stopped.emit()
	else:
		if !was_moving:
			was_moving = true
			ball_relaunched.emit()
			
	if show_timer > 0.0:
		show_timer -= delta
		if show_timer <= 0.0:
			arrow_sprite.visible = false
			
	_emit_slow_motion_factor()
	#if Input.is_action_just_pressed("attack"):  # o cualquier tecla para test
		#var test_dir = Vector2.RIGHT.rotated(randf() * TAU)
		#indicator.rotation = test_dir.angle()
		#indicator.visible = true
		#print("Flecha rotada hacia:", test_dir.angle())

func _launch_ball(direction: Vector2) -> void:
	var dir = direction.normalized()
	linear_velocity = dir * launch_speed
	ball_relaunched.emit()
	

# 2) Cuando la señal damage_dealt te da la posición del atacante:
func _on_damage_dealt(target_position: Vector2) -> void:
	print("¡La pelota fue golpeada en posición ", target_position, "!")
	var direction = global_position - target_position
	_launch_ball(direction) ##### OPCIONAL
	_show_hit_indicator(direction)
	
	
# 3) Cuando te llaman con un vector de dirección:
func take_damage(damage: float, from_direction: Vector2) -> void:
	print("¡La pelota recibió daño con dirección ", from_direction, "!")
	_launch_ball(from_direction)
	_show_hit_indicator(from_direction)
	
	# Calcular la distancia de offset teniendo en cuenta el scale aplicado
	#var offset_distance := arrow_sprite.texture.get_width() * 0.5 * arrow_sprite.scale.x
	#var offset := from_direction.normalized() * offset_distance
#
	#
	## Posicionar la flecha desde el centro de la pelota
	#indicator.position = Vector2.ZERO
	#arrow_sprite.position = offset
	#arrow_sprite.rotation = from_direction.angle()
	#arrow_sprite.visible = true
	#arrow_sprite.z_index = 10
	#
	## Mostrar flecha solo por feedback visual
	#if from_direction.length() > 0:
		#show_timer = show_duration
		#
func _show_hit_indicator(from_direction: Vector2) -> void:
	if from_direction.length() == 0:
		return
	var offset_distance := arrow_sprite.texture.get_width() * 0.5 * arrow_sprite.scale.x
	var offset := from_direction.normalized() * offset_distance

	indicator.position = Vector2.ZERO
	arrow_sprite.position = offset
	arrow_sprite.rotation = from_direction.angle()
	arrow_sprite.visible = true
	arrow_sprite.z_index = 10
	show_timer = show_duration


func _emit_slow_motion_factor():
	var speed = linear_velocity.length()
	var factor := max_time_scale

	if speed < speed_threshold:
		var t = clamp(speed / speed_threshold, 0.0, 1.0)
		factor = lerp(min_time_scale, max_time_scale, t)

	ball_speed_changed.emit(factor)
