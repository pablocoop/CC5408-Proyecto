extends MarginContainer
@onready var tutorial: Button = $PanelContainer/MarginContainer/VBoxContainer/Tutorial
@onready var level_1: Button = $PanelContainer/MarginContainer/VBoxContainer/Level1
@onready var back: Button = $PanelContainer/MarginContainer/VBoxContainer/Back


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tutorial.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/level_0.tscn"))
	level_1.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/level_1.tscn"))
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://ui/main_menu.tscn"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
