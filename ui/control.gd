extends Control
@onready var back: Button = $VBoxContainer/Back


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://ui/main_menu.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
