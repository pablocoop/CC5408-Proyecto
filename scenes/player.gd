class_name Player
extends CharacterBody2D

signal proximity_entered(ball)
signal proximity_exited(ball)

@onready var proximity_check: Area2D = $ProximityCheck

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

@onready var health_bar: ProgressBar = %HealthBar
@onready var health_component: HealthComponent = $HealthComponent

var input: Vector2
var playback: AnimationNodeStateMachinePlayback

@export var animation_tree: AnimationTree

func _ready() -> void:
	playback = animation_tree["parameters/playback"]
	proximity_check.area_entered.connect(_on_area_entered)
	proximity_check.area_exited.connect(_on_area_exited)
	proximity_entered.connect(func(ball): ball.set_player_nearby(true))
	proximity_exited.connect(func(ball): ball.set_player_nearby(false))
	
	health_component.health_changed.connect(_on_health_changed)
	health_bar.value = health_component.health
	health_bar.max_value = health_component.max_health
	health_component.died.connect(death)
	
func _on_area_entered(area: Area2D) -> void:
	var ball = area.get_parent() as Ball
	if ball and ball.has_method("set_player_nearby"):
		proximity_entered.emit(ball)

func _on_area_exited(area: Area2D) -> void:
	var ball = area.get_parent() as Ball
	if ball and ball.has_method("set_player_nearby"):
		proximity_exited.emit(ball)

func _process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale
	animation_tree.advance(real_delta)
	
func _physics_process(delta: float) -> void:
	var real_delta = delta / Engine.time_scale
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	is_running = Input.is_action_pressed("run")
	
	var current_speed = speed * run_multiplier if is_running else speed
	var direction = input.normalized()
	velocity = direction * current_speed * real_delta / delta  # Compensar el slowdown
	
	move_and_slide()
	_select_animation()
	_update_animation_parameters()


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
	if is_dead:
		return

	current_health -= damage

	if current_health > 0:
		is_taking_damage = true
		Debug.log("auch! pero sigo vivo")

		# Rebote: aplica una pequeña fuerza pero no excesiva
		#velocity = from_direction.normalized() * (max_speed * 0.5)
		
		is_invulnerable = true
		start_invulnerability()
		flash_red()
		await get_tree().create_timer(0.5).timeout  # duración de animación
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
	
func death() -> void:
	queue_free()
