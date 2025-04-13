extends CharacterBody2D

@export var max_speed = 250
@export var acceleration = 900
@export var max_health := 3
var current_health := max_health
var is_dead := false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot: Node2D = $Pivot
@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D


func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
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
		playback.travel("take_damage")
	else:
		is_dead = true
		playback.travel("death")
		# Esperamos al final de la animación antes de eliminar
		await get_tree().create_timer(0.5).timeout  # ajusta si tu animación dura más/menos
		queue_free()

	# Rebote (aplicar una fuerza contraria a la dirección desde donde fue golpeado)
	velocity = from_direction.normalized() * max_speed
