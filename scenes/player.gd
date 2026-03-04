extends CharacterBody2D

#set a default speed, export it to be able to change it in the editor
@export var speed: int = 200

#canShoot variable to control the shooting rate
var canShoot: bool = true

#signal to notify when the player shoots, sending the laser position
signal laser_shoot(laserPosition)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:

	#detect the input direction and move the player, set directons from project settings input map
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1.

	#makes it so diagonal movement isn't faster
	direction = direction.normalized()

	#set the velocity to the direction times the speed
	velocity = direction * speed

	#move the player
	#use move_and_slide() to move the player, it takes care of sliding on collisions, part of CharacterBody2D
	move_and_slide()

	#recognizing input from switch controller using the input helper plugin
	#check if the device index is not 1 (not a switch controller)
	if $inputHelper.device_index != 1:
		#check for shoot input and if the player can shoot, more useful for is_action_pressed because you can hold the button down then, but here we want just a single press anyways
		if Input.is_action_just_pressed("shoot") and canShoot:	
			#emit the laser_shoot signal with the position of the laser start point, global position to account for parent transforms
			laser_shoot.emit($laserStart.global_position)
			#play the laser sound
			$laserSound.play()
			#disable shooting and start the laser timer
			canShoot = false
			$laserTimer.start()
		pass
	else:
		#check for shoot input for the switch controller and if the player can shoot
		if Input.is_action_just_pressed("shootNintendo") and canShoot: 	
			laser_shoot.emit($laserStart.global_position)
			$laserSound.play()
			canShoot = false
			$laserTimer.start()
		pass

func _mobile_shoot():
	
	pass

#Obtained from a signal connection in the editor, specifically from a Timer node
func _on_laser_timer_timeout() -> void:
	#re-enable shooting when the timer times out
	canShoot = true
	pass # Replace with function body.
