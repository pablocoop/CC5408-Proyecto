class_name Ball
extends RigidBody2D

signal ball_stopped
signal ball_relaunched
signal ball_speed_changed(slow_motion_factor: float)

@export var max_time_scale := 1.0
@export var min_time_scale := 0.2
@export var speed_threshold := 100.0  # Velocidad a partir de la cual el mundo empieza a ralentizarse

@export var launch_speed = 1200
var was_moving := false
var player_nearby := false

@onready var hitbox: Hitbox = $Hitbox
var has_moved := false  # Variable que indica si la pelota ha sido lanzada

func _ready():
	hitbox.damage_dealt.connect(_on_damage_dealt)
	linear_damp = 0.8
	randomize()
	
func set_player_nearby(value: bool) -> void:
	player_nearby = value
 
func _physics_process(delta: float) -> void:
	# Lanzar bola si se ataca estando detenida o en movimiento
	if Input.is_action_just_pressed("attack") and player_nearby:
		var angle = position.direction_to(get_global_mouse_position()).angle()
		var direction = Vector2.RIGHT.rotated(angle).normalized()
		linear_velocity = direction * launch_speed

		# Limitar velocidad al valor máximo
		linear_velocity = linear_velocity.limit_length(launch_speed)
		
		if !was_moving:
			was_moving = true
			has_moved = true  # Marca que la pelota se ha movido
			ball_relaunched.emit()

	if linear_velocity.length() < 15:
		if was_moving:
			was_moving = false
			ball_stopped.emit()
	else:
		if !was_moving:
			was_moving = true
			ball_relaunched.emit()
			
	_emit_slow_motion_factor()

func _on_damage_dealt(target_position: Vector2):
	var direction = global_position - target_position
	linear_velocity = direction.normalized() * linear_velocity.length()

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox:
		if linear_velocity.length() > 0:
			linear_velocity = -linear_velocity.normalized() * linear_velocity.length()
			ball_relaunched.emit()

func _emit_slow_motion_factor():
	var speed = linear_velocity.length()
	var factor := max_time_scale

	if speed < speed_threshold:
		var t = clamp(speed / speed_threshold, 0.0, 1.0)
		factor = lerp(min_time_scale, max_time_scale, t)

	ball_speed_changed.emit(factor)
