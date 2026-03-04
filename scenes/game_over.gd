extends Control

var mainMenu: PackedScene = load("res://scenes/main_menu.tscn")


func _ready() -> void:
	$score.text = "Your score: " + str(Global.score)
	if !DisplayServer.is_touchscreen_available(): 
		$shootButton.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(_event) -> void:

	if $inputHelper.device_index != 1: 	
		if Input.is_action_pressed("shoot"):
			Global.score = 0
			Global.health = 3
			get_tree().change_scene_to_packed(mainMenu)
			pass
	else:
		if Input.is_action_pressed("shootNintendo"):
			Global.score = 0
			Global.health = 3
			get_tree().change_scene_to_packed(mainMenu)
			pass


func _on_shoot_button_button_down() -> void:
			Global.score = 0
			Global.health = 3
			get_tree().change_scene_to_packed(mainMenu)
