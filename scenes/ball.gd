class_name Ball
extends RigidBody2D

@onready var combo_sound = $combo_sound

signal ball_stopped
signal ball_relaunched

@export var launch_speed = 1200
@export var extra_boost_on_hit = 2.2
@export var max_speed = 500
var was_moving := false
var player_nearby := false

var boost= 1
var combo_counter: int = 0

#experiment


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
	if Input.is_action_just_pressed("attack") and player_nearby : #and !was_moving 
		var angle = position.direction_to(get_global_mouse_position()).angle()
		var direction = Vector2.RIGHT.rotated(angle).normalized()
		linear_velocity = direction * launch_speed
		
	if Input.is_action_just_pressed("reset"):
		global_position= Vector2(500,300)
		
		
		

		# Fuerza el cambio a estado "en movimiento"
		if !was_moving:
			was_moving = true
			ball_relaunched.emit()

	# Detectar si se detuvo
	if linear_velocity.length() < 15:
		if was_moving:
			was_moving = false
			ball_stopped.emit()
			combo_counter= 0
	else:
		if !was_moving:
			was_moving = true
			ball_relaunched.emit()
			
		
func combo_increase(position: Vector2):
	#sound: 
	combo_sound.pitch_scale= 0.8 + combo_counter*0.2
	combo_sound.play()
	
	
#combo managment
	combo_counter +=1
	var combo_text: RichTextLabel = RichTextLabel.new()
	combo_text.custom_minimum_size = Vector2(100,100)
	
	
	combo_text.set("theme_override_constants/outline_size", 2)
	combo_text.set("theme_override_colors/font_outline_color", Color.BLACK)
	combo_text.fit_content=true
	combo_text.scroll_active=false
	combo_text.top_level=true
	combo_text.position=position
	combo_text.custom_minimum_size = Vector2(100*combo_counter,100)
	combo_text.push_font_size(12+log(combo_counter)*15)

	combo_text.append_text("[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0][shake rate="+ str(10+ combo_counter)+" level="+ str(min(combo_counter,7)) +"connected=1]  COMBO x" + str(combo_counter))
	
	add_child(combo_text)
	await get_tree().create_timer(0.8).timeout
	combo_text.queue_free()
	

func _on_damage_dealt(target_position: Vector2):
	
	combo_increase(target_position)
	#primero ver si no tiene demasiada velocidad
	if linear_velocity.length() > max_speed:
		boost= 1
	else:
		boost= extra_boost_on_hit
	
	var direction = global_position - target_position
	linear_velocity = direction.normalized() * linear_velocity.length() * boost

#func _on_area_entered(area: Area2D) -> void:
	#var hitbox = area as Hitbox
	#if hitbox:
		## Rebote inverso: opuesto a la dirección actual
		#if linear_velocity.length() > 0:
			#linear_velocity = -linear_velocity.normalized() * linear_velocity.length()
			#ball_relaunched.emit()
