extends CharacterBody2D

@export var max_speed = 250
@export var acceleration = 900
@export var max_health := 3
var current_health := max_health
var is_taking_damage = false
var is_dead := false
var is_invulnerable := false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot: Node2D = $Pivot
@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D
@onready var hurtbox: Hurtbox = $Pivot/Hurtbox



func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	if is_dead or is_invulnerable:
		return
		
	if is_taking_damage:
		return  # no moverse ni reproducir "movement" durante la animación de daño
		
	velocity.x = move_toward(velocity.x, max_speed * pivot.scale.x, acceleration * delta)
	playback.travel("movement")
	move_and_slide()
	
	if ray_cast_2d.is_colliding():
		pivot.scale.x *= -1

func take_damage(damage: float, from_direction: Vector2) -> void:
	if is_dead:
		return

	current_health -= damage

	if current_health > 0:
		is_taking_damage = true
		Debug.log("auch! pero sigo vivo")

		# Rebote: aplica una pequeña fuerza pero no excesiva
		#velocity = from_direction.normalized() * (max_speed * 0.5)

		playback.travel("take_damage")
		
		is_invulnerable = true
		start_invulnerability()
		flash_red()
		await get_tree().create_timer(0.5).timeout  # duración de animación
		velocity = Vector2.ZERO  # Detener el impulso tras el rebote
		is_taking_damage = false
	else:
		is_dead = true
		Debug.log("auch! he muerto!")
		playback.travel("death")
		flash_red()
		await get_tree().create_timer(1.5).timeout
		queue_free()
		
func flash_red() -> void:
	modulate = Color(1, 0.7, 0.7)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	
func start_invulnerability():
	var flash_timer := 0.0
	var flash_duration := 0.5  # duración total de la invulnerabilidad (en segundos)
	var flash_interval := 0.2  # tiempo entre parpadeos
	hurtbox.monitoring = false

	while flash_timer < flash_duration:
		visible = false
		await get_tree().create_timer(flash_interval / 2).timeout
		visible = true
		await get_tree().create_timer(flash_interval / 2).timeout
		flash_timer += flash_interval

	is_invulnerable = false
	hurtbox.monitoring = true
