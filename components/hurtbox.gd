class_name Hurtbox
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	Debug.log("hurtbox")
	Debug.log(area)
