extends Control

var tween := create_tween()
var startPressed := false
var creditsPressed:= false

func _ready() -> void:
	tween.tween_property($MarginContainer, "modulate:a", 0, 0)
	tween.play()
	tween.tween_property($MarginContainer, "modulate:a", 1, 5)

func _on_start_button_down() -> void:
	startPressed = true
	creditsPressed = false
	$confirmNoise.play()

func _on_credits_button_down() -> void:
	creditsPressed = true
	startPressed = false
	$confirmNoise.play()

func _on_confirm_noise_finished() -> void:
	if startPressed:
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	if creditsPressed:
		get_tree().change_scene_to_file("res://scenes/credits.tscn")




func _on_godot_license_button_down() -> void:
	$confirmNoise.play()
