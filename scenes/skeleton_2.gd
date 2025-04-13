extends CharacterBody2D

@export var max_speed = 1000
@export var walk_speed = 250
@export var acceleration = 400
@export var attacking = false
@export var moving = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var pivot: Node2D = $Pivot
@onready var ray_cast_2d: RayCast2D = $Pivot/RayCast2D


func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	playback.travel("movement")
	velocity.x = move_toward(velocity.x, walk_speed * pivot.scale.x, acceleration * delta)
	move_and_slide()
	if ray_cast_2d.is_colliding():
		pivot.scale.x *= -1

func take_damage(damage: float) -> void:
	queue_free()
