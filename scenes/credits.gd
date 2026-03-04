extends Control

var tween := create_tween()

func _ready() -> void:
	tween.tween_property($credits, "position:y", -11878.0, 60)
	await get_tree().create_timer(60).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
