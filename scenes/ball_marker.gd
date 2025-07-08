extends Control

@export var ball_node: Node2D
@onready var texture_rect: TextureRect = $TextureRect

const POINTERBALL = preload("res://assets/assets ui/pointerball.png")

var camera_zoom

func _ready() -> void:
	camera_zoom = get_viewport().get_camera_2d().zoom

func _process(delta) -> void:
	if not is_instance_valid(ball_node): return
	
	var ball_target_position = ball_node.global_position
	if ball_target_position == Vector2.ZERO: return
	
	var ball_target_screen_position = (ball_target_position - _get_camera_rect().position) * camera_zoom
	
	if not _target_on_screen(ball_target_position):
		texture_rect.texture = POINTERBALL
		_set_screen_position(ball_target_screen_position)
		_rotate_to_target(ball_target_position)
		
		
	
func  _get_camera_rect() -> Rect2: 
	var pos = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_size = get_viewport_rect().size / camera_zoom
	
	return Rect2(pos - screen_size / 2, screen_size)

func _target_on_screen(target_position: Vector2) -> bool:
	return _get_camera_rect().has_point(target_position)

func _set_screen_position(screen_target_position: Vector2) -> void:
	var screen_size = get_viewport_rect().size
	var borderOffSet = 50
	var target_position = screen_target_position
	
	target_position.x = clamp(target_position.x, borderOffSet, screen_size.x - borderOffSet)
	target_position.y = clamp(target_position.y, borderOffSet, screen_size.y - borderOffSet)
		
	global_position = target_position

func _rotate_to_target(target_position: Vector2) -> void:
	var current_position = get_viewport().get_camera_2d().get_screen_center_position()
	var direction = (target_position - current_position).normalized()
	
	rotation = direction.angle()
