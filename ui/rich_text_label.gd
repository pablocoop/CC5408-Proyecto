extends RichTextLabel

var colors = [
	Color(1, 0, 0),   # rojo
	Color(1, 1, 0),   # amarillo
	Color(0, 1, 0),   # verde
	Color(0, 1, 1),   # cian
	Color(0, 0, 1),   # azul
	Color(1, 0, 1),   # magenta
]

var current_color_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = colors[0]
	next_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func next_color():
	var next_index = (current_color_index + 1) % colors.size()
	var from_color = colors[current_color_index]
	var to_color = colors[next_index]
	current_color_index = next_index

	var tween = create_tween()
	tween.tween_property(self, "modulate", to_color, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(next_color) # cuando termine, llama otra vez
