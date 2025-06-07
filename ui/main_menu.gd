extends MarginContainer
@onready var start: Button = $PanelContainer/MarginContainer/VBoxContainer/Start
@onready var quit: Button = $PanelContainer/MarginContainer/VBoxContainer/Quit
@onready var credits: Button = $PanelContainer/MarginContainer/VBoxContainer/Credits
@onready var controls: Button = $PanelContainer/MarginContainer/VBoxContainer/Controls


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(func(): get_tree().quit())
	credits.pressed.connect(func(): get_tree().change_scene_to_file("res://ui/credits.tscn"))
	controls.pressed.connect(func(): get_tree().change_scene_to_file("res://ui/control.tscn"))
	
func _on_start_pressed() -> void:
	#Game.life = 7  # Reinicia las vidas
	# modificar a un selector niveles ! o al level 0 (main)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
