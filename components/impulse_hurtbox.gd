extends Area2D

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox and owner.has_method("_on_damage_dealt"):
		print("✅ ¡Era un hitbox! Emitiendo daño...")
		owner._on_damage_dealt(hitbox.global_position)  # 👈 Llama directo al dueño
