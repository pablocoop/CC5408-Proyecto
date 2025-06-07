class_name Player
extends CharacterBody2D

#signal proximity_entered(ball)
#signal proximity_exited(ball)

#@onready var proximity_check: Area2D = $ProximityCheck

@export var speed = 400
@export var acceleration = 900
@export var max_health := 10
var current_health := max_health
var is_running := false
@export var run_multiplier := 1.5
@onready var texture_progress_bar: TextureProgressBar = $HealthBar/TextureProgressBar
var is_taking_damage = false
var is_dead := false
var is_invulnerable := false
var is_paused := false
@onready var hurtbox: Hurtbox = $Hurtbox

# Golpear la pelota
@onready var attack_hitbox: Hitbox = $AttackHitbox
@onready var attack_hitbox_shape: CollisionShape2D = $AttackHitbox/CollisionShape2D

@export var attack_duration := 0.1
@export var attack_cooldown := 0.1
var can_attack := true
var facing_direction := Vector2.DOWN  # Dirección inicial por defecto
var attack_direction := Vector2.ZERO




# Knockback
var knockback_vector := Vector2.ZERO
var knockback_timer := 0.5
@export var knockback_duration := 0.5
@export var knockback_force := 600.0

# Barra de vida
@onready var health_bar: ProgressBar = %HealthBar
@onready var health_component: HealthComponent = $HealthComponent

# Barra de stamina
var stamina = 4
var max_stamina = 4
@onready var stamina_bar: ProgressBar = %StaminaBar
@export var stamina_decrease_interval := 0.5  # cada 0.5s se descuenta 1
@export var stamina_recover_interval := 0.2  # cada 0.2s se recupera 1
@export var stamina_recover_delay := 1.0     # espera 1s tras dejar de correr
@export var stamina_per_tick := 1

var stamina_timer := 0.0
var recovering_stamina := false
var stamina_recover_timer := 0.0
var stamina_locked := false  # impide correr si no hay stamina suficiente
# otros
var input: Vector2
var playback: AnimationNodeStateMachinePlayback

@export var animation_tree: AnimationTree



func _ready() -> void:
	playback = animation_tree["parameters/playback"]
	#proximity_check.area_entered.connect(_on_area_entered)
	#proximity_check.area_exited.connect(_on_area_exited)
	#proximity_entered.connect(func(ball): ball.set_player_nearby(true))
	#proximity_exited.connect(func(ball): ball.set_player_nearby(false))
	
	health_component.health_changed.connect(_on_health_changed)
	health_bar.value = health_component.health
	health_bar.max_value = health_component.max_health
	health_component.died.connect(death)
	
	stamina_bar.value = stamina
	stamina_bar.max_value = max_stamina
	
	#DEV: Borrar sprite de ataque
	attack_hitbox.get_node("Sprite2D").visible = false 
	


func _process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale
	animation_tree.advance(real_delta)
	
	# Ajustar posición de la hitbox como antes
	attack_hitbox.global_position = global_position + facing_direction * 32

	# Rotar visualmente el sprite del ataque
	var angle = facing_direction.angle()
	attack_hitbox.get_node("Sprite2D").rotation = angle
	
func _physics_process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	is_running = Input.is_action_pressed("run") and not stamina_locked and stamina > 0
	
	var current_speed = speed * run_multiplier if is_running else speed
	var direction = input.normalized()
	velocity = direction * current_speed * real_delta / delta  # Compensar el slowdown
	
	
	if Input.is_action_just_pressed("attack"):
		attack_direction = facing_direction.normalized()
		_attack()
	
	if input != Vector2.ZERO:
		facing_direction = input.normalized()
		
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity += knockback_vector
		# Puedes agregar amortiguación si quieres que el empuje disminuya gradualmente
		knockback_vector *= 0.9  # opcional
	else:
		knockback_vector = Vector2.ZERO
		
		
	move_and_slide()
	_select_animation()
	_update_animation_parameters()
	
		# Lógica de gasto de stamina al correr
	if is_running and input != Vector2.ZERO and stamina > 0:
		stamina_timer += real_delta
		stamina_recover_timer = 0.0
		recovering_stamina = false

		if stamina_timer >= stamina_decrease_interval:
			stamina_timer = 0.0
			stamina = max(stamina - stamina_per_tick, 0)
			stamina_bar.value = stamina
			
			if stamina <= 0:
				is_running = false  # ya no puede correr si no tiene stamina
	else:
		# Comenzar recuperación después de un retardo
		stamina_recover_timer += real_delta
		if stamina_recover_timer >= stamina_recover_delay:
			recovering_stamina = true
	
	# Recuperación progresiva de stamina
	if recovering_stamina and stamina < max_stamina:
		stamina_timer += real_delta
		if stamina_timer >= stamina_recover_interval:
			stamina_timer = 0.0
			stamina += stamina_per_tick
			stamina = min(stamina, max_stamina)
			stamina_bar.value = stamina

func _select_animation() -> void:
	if velocity == Vector2.ZERO:
		playback.travel("idle")
	elif is_running:
		playback.travel("running")	
	else:
		playback.travel("walking")
	
func _update_animation_parameters() -> void:
	if input == Vector2.ZERO:
		return
	animation_tree["parameters/idle/blend_position"] = input
	animation_tree["parameters/walking/blend_position"] = input
	animation_tree["parameters/running/blend_position"] = input

func _input(event: InputEvent) -> void:
	pass
	
	

func take_damage(damage: float, from_direction: Vector2) -> void:
	if is_dead or is_invulnerable:
		move_and_slide()
		return

	# Reducir la salud desde el componente
	health_component.health -= damage

	if health_component.health > 0:
		is_taking_damage = true
		Debug.log("auch! pero sigo vivo")

		# Aplicar knockback
		knockback_vector = -from_direction.normalized() * knockback_force
		knockback_timer = knockback_duration

		is_invulnerable = true
		start_invulnerability()
		flash_red()
		await get_tree().create_timer(0.5).timeout
		is_taking_damage = false
	else:
		is_dead = true
		Debug.log("auch! he muerto!")
		flash_red()
		queue_free()

		
func flash_red() -> void:
	modulate = Color(1, 0.7, 0.7)
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)
	
func start_invulnerability():
	hurtbox.monitoring = false
	is_invulnerable = false
	hurtbox.monitoring = true
			

func _on_health_changed(value:float) -> void:
	health_bar.value = value

func _attack():
	if not can_attack:
		return
		
	can_attack = false
	#is_invulnerable = true 	### DEVUG ONLY
	#start_invulnerability() # DEVUG ONLY
	attack_hitbox.direction = attack_direction
	attack_hitbox.monitoring = true
	attack_hitbox_shape.disabled = false
	attack_hitbox.get_node("Sprite2D").visible = true 

	await get_tree().create_timer(attack_duration).timeout
	attack_hitbox.monitoring = false
	attack_hitbox_shape.disabled = true  # Desactivar colisión visual
	attack_hitbox.get_node("Sprite2D").visible = false 
	is_invulnerable = false # DEVUG ONLY
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	
func death() -> void:
	queue_free()
	
