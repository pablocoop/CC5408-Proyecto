extends CharacterBody2D

@export var max_speed = 250
@export var acceleration = 900
@onready var health_component: HealthComponent = $HealthComponent
var is_taking_damage = false
var is_dead := false
var is_invulnerable := false
var is_paused := false
# Guardamos la velocidad base para escalarla después
var base_max_speed := 0.0
@export var knockback_duration := 0.1
@export var knockback_force := 200.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot: Node2D = $Pivot
@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D
@onready var hurtbox: Hurtbox = $Pivot/Hurtbox
@onready var hitbox: Hitbox = $Pivot/Hitbox

signal enemy_died
@onready var die: AudioStreamPlayer = $die



func _ready() -> void:
	animation_tree.active = true
	add_to_group("enemies")
	health_component.died.connect(death)
	base_max_speed = max_speed
	call_deferred("_connect_slowmo")
	hitbox.damage_dealt.connect(_on_hitbox_damage_dealt)
	#var balls = get_tree().get_nodes_in_group("ball")
	#if balls.size() > 0:
		#balls[0].ball_speed_changed.connect(_on_slowmo_factor)

func _physics_process(delta: float) -> void:
	if is_paused:
		playback.travel("idle")
		return
		
	if is_dead or is_taking_damage:
		#move_and_slide()  # Evitar fricción infinita si ya tiene velocidad
		return  # no moverse ni reproducir "movement" durante la animación de daño
		
	velocity.x = move_toward(velocity.x, max_speed * pivot.scale.x, acceleration * delta)
	playback.travel("movement")
	move_and_slide()
	
	if ray_cast_2d.is_colliding():
		pivot.scale.x *= -1

func take_damage(damage: float, from_direction: Vector2) -> void:
	die.play()
	
	if is_dead or is_invulnerable:
		return

	health_component.health -= damage

	if health_component.health > 0:
		is_taking_damage = true
		Debug.log("🔥 Skeleton recibió daño:", damage)

		# Aplica un knockback más leve que al jugador
		velocity = from_direction.normalized() * knockback_force  # Ajusta a gusto
		
		playback.start("take_damage")
		
		is_invulnerable = true
		start_invulnerability()
		flash_red()
		await get_tree().create_timer(knockback_duration).timeout
		velocity = Vector2.ZERO
		is_taking_damage = false
	else:
		is_dead = true
		Debug.log("💀 Skeleton murió")
		emit_signal("enemy_died")
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
	var flash_duration := 0.3  # duración total de la invulnerabilidad (en segundos)
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
	
func _connect_slowmo() -> void:
	for b in get_tree().get_nodes_in_group("ball"):
		b.ball_speed_changed.connect(_on_slowmo_factor)

func _on_slowmo_factor(factor: float) -> void:
	# Solo escalamos la velocidad de movimiento
	max_speed = base_max_speed * factor

	# Opcional: si quieres escalar también la animación, 
	# y tu AnimationTree lo soporta, podrías hacer:
	animation_tree.set("parameters/playback/speed_scale", factor)
	# ó si usas AnimationPlayer:
	# $AnimationPlayer.playback_speed = factor
func _on_hitbox_damage_dealt(target_position: Vector2) -> void:
	# target_position es la posición del jugador cuando recibió el daño
	# Solo disparamos la animación (el daño ya se aplicó en el Hurtbox del Player)
	playback.travel("attack")
func pause_enemy():
	is_paused = true

func resume_enemy():
	is_paused = false
	
func death() -> void:
	is_dead = true
	playback.travel("death")
	await get_tree().create_timer(1.5).timeout
	queue_free()
