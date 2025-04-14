class_name Ball
extends RigidBody2D

signal ball_stopped
signal ball_relaunched

@export var launch_speed = 1200
var was_moving := false
var player_nearby := false

@onready var hitbox: Hitbox = $Hitbox


func _ready():
	hitbox.damage_dealt.connect(_on_damage_dealt)
	# Simula fricción
	linear_damp = 0.8
	# Asegura random distinto cada vez
	randomize()
	
func set_player_nearby(value: bool) -> void:
	player_nearby = value
 
func _physics_process(delta: float) -> void:
	# Lanzar bola si se ataca estando detenida
	if Input.is_action_just_pressed("attack") and !was_moving and player_nearby:
		var angle = position.direction_to(get_global_mouse_position()).angle()
		var direction = Vector2.RIGHT.rotated(angle).normalized()
		linear_velocity = direction * launch_speed

		# Fuerza el cambio a estado "en movimiento"
		if !was_moving:
			was_moving = true
			ball_relaunched.emit()

	# Detectar si se detuvo
	if linear_velocity.length() < 15:
		if was_moving:
			was_moving = false
			ball_stopped.emit()
	else:
		if !was_moving:
			was_moving = true
			ball_relaunched.emit()
			
		
func _on_damage_dealt(target_position: Vector2):
	var direction = global_position - target_position
	linear_velocity = direction.normalized() * linear_velocity.length()

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox:
		# Rebote inverso: opuesto a la dirección actual
		if linear_velocity.length() > 0:
			linear_velocity = -linear_velocity.normalized() * linear_velocity.length()
			ball_relaunched.emit()
