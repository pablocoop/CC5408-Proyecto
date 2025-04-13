extends RigidBody2D

@export var max_speed = 800
@export var moving = false
@onready var hitbox: Hitbox = $Hitbox


func _ready():
	hitbox.damage_dealt.connect(_on_damage_dealt)
	# Simula fricción
	linear_damp = 0.35
	# Asegura random distinto cada vez
	randomize()
 
func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("attack") and !moving:
		var angle = position.direction_to(get_global_mouse_position()).angle()
		#var angle = randf_range(0, TAU)
		var direction = Vector2.RIGHT.rotated(angle).normalized()
		linear_velocity = direction * max_speed
		moving = true
	# Si la velocidad es muy baja, consideramos que se detuvo
	#Debug.log(linear_velocity.length())
	if moving and linear_velocity.length() < 20:  # Puedes ajustar el umbral
		moving = false
		
func _on_damage_dealt(target_position: Vector2):
	var direction = global_position - target_position
	linear_velocity = direction.normalized() * linear_velocity.length()
