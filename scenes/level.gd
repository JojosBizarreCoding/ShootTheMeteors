extends Node2D

#Load the meteor scene
var meteorScene: PackedScene = load("res://scenes/meteor.tscn")
var laserScene: PackedScene = load("res://scenes/laser.tscn")

#health variable to track player health
var health : int = Global.health

var hurtable: bool = true

var canShoot: bool = true

var isMobile: bool = true

func _ready() -> void:
	#use a the UI group to call the updateHealth function in the game_ui script
	get_tree().call_group("UI", "updateHealth", health)

	if !DisplayServer.is_touchscreen_available() :
		$Joystick.queue_free()
		$shootButton.queue_free()
		isMobile = false

#Obtained from a signal connection in the editor, specofically from a Timer node
func _on_meteor_timer_timeout() -> void:
	#Instantiate a meteor from the scene
	var meteor = meteorScene.instantiate()

	#Attach the meteor to the current scene tree
	$meteors.add_child(meteor)

	#connect signal from meteor to level
	meteor.connect("collisionDetected", _on_meteor_collision)

func _on_meteor_collision() -> void:
	print(health)
	if hurtable:
		health -= 1
		hurtable = false
		$hitTimer.start()
		$sounds/playerHitSound.play()
		get_tree().call_group("UI", "updateHealth", health)
	if health == 1:
		$sounds/alarmSound.play()
	if health <= 0:
		$player.queue_free()
		if isMobile:
			$shootButton.queue_free()
		$sounds/playerDeathSound.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_player_laser_shoot(laserPosition) -> void:
	var laser = laserScene.instantiate()
	$lasers.add_child(laser)
	laser.position = laserPosition
	pass # Replace with function body.


func _on_hit_timer_timeout() -> void:
	hurtable = true
	pass # Replace with function body.


func _on_shoot_button_button_down() -> void:
	if canShoot:
	#emit the laser_shoot signal with the position of the laser start point, global position to account for parent transforms
		var laserPosition : Vector2= $player/laserStart.global_position
		#play the laser sound
		$player/laserSound.play()
		#disable shooting and start the laser timer
		$player/laserTimer.start()
		var laser = laserScene.instantiate()
		$lasers.add_child(laser)
		laser.position = laserPosition
