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
var has_moved := false  # Variable que indica si la pelota ha sido lanzada

@onready var hurtbox: Area2D = $Hurtbox


func _ready():
	hitbox.damage_dealt.connect(_on_damage_dealt)
	# Conectar sólo al hitbox de ataque del jugador:
	#var players = get_tree().get_nodes_in_group("player")
	#if players.size() > 0:
		#var p = players[0]
		#var atk = p.get_node("AttackHitbox") as Hitbox
		#if atk:
			#atk.damage_dealt.connect(_on_damage_dealt)
	add_to_group("ball")
	linear_damp = 0.8
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
			
	_emit_slow_motion_factor()

func _launch_ball(direction: Vector2) -> void:
	var dir = direction.normalized()
	linear_velocity = dir * launch_speed
	ball_relaunched.emit()
	

# 2) Cuando la señal damage_dealt te da la posición del atacante:
func _on_damage_dealt(target_position: Vector2) -> void:
	print("¡La pelota fue golpeada en posición ", target_position, "!")
	var direction = global_position - target_position
	_launch_ball(direction) ##### OPCIONAL
	
# 3) Cuando te llaman con un vector de dirección:
func take_damage(damage: float, from_direction: Vector2) -> void:
	print("¡La pelota recibió daño con dirección ", from_direction, "!")
	_launch_ball(from_direction)


func _emit_slow_motion_factor():
	var speed = linear_velocity.length()
	var factor := max_time_scale

	if speed < speed_threshold:
		var t = clamp(speed / speed_threshold, 0.0, 1.0)
		factor = lerp(min_time_scale, max_time_scale, t)

	ball_speed_changed.emit(factor)
