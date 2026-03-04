extends Area2D

signal collisionDetected()

@export var speed: int = 300

var canHit: bool = true

#create a random number generator, which is thankfully just included in Godot
var random := RandomNumberGenerator.new()

#random scale between 2.0 and 5.0
var randomScale = random.randf_range(2.0, 5.0)

var randomXDirection = random.randf_range(-1.0, 1.0)

#random a rotation between 0 and 360 degrees
var randomStartRotation = random.randf_range(0.0, 360.0)

#random rotation speed between -20 and 20 degrees per second
var randomRotationSpeed = random.randf_range(-20.0, 20.0)



#load a palette texture to use in the shader
var defaultPalette: Texture2D = preload("res://assets/pallets/defaultPalette.png")
var purplePalette: Texture2D = preload("res://assets/pallets/purplePalette.png")  
var bluePalette: Texture2D = preload("res://assets/pallets/bluePalette.png")
var brownPalette: Texture2D = preload("res://assets/pallets/brownPalette.png")
var peePalette: Texture2D = preload("res://assets/pallets/peePalette.png")


#palette array to choose from
var paletteArray = [defaultPalette, purplePalette, bluePalette, brownPalette, peePalette]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#duplicate assures every meteor is unqiue
	$meteorSprite.material = $meteorSprite.material.duplicate()
	#get the shader parameter from the sprite and set it to the palette texture randomly chosen from the palette array
	$meteorSprite.material.get_shader_parameter("output_palette_texture")
	$meteorSprite.material.set_shader_parameter("output_palette_texture", paletteArray[random.randi_range(0, paletteArray.size() - 1)])

	#Set width from vierwport size
	var width = get_viewport().get_visible_rect().size[0]

	#Random x position within the width of the screen, and a random y position above the screen
	var random_x = random.randi_range(0, width)
	var random_y = random.randi_range(-100, -50)
	
	#Set the position of the meteor to the random position
	position = Vector2(random_x, random_y)

	#Set the scale of the meteor to the random scale
	scale = Vector2(randomScale, randomScale)

	#Set the rotation of the meteor to the random rotation, converting degrees to radians
	rotation_degrees = randomStartRotation

func _process(delta: float) -> void:
	
		#Move the meteor down the screen, speed is 300 pixels per second
		position += Vector2(randomXDirection, 1) * speed * delta

		#Rotate the meteor, using delta to make it frame rate independent
		rotate(randomRotationSpeed * delta / 10)

		#If the meteor goes off the bottom of the screen, remove it from the scene tree
		if position.y > get_viewport().get_visible_rect().size[1] + 50:
			queue_free()

#Obtained from a signal connection in the editor, specifically from the Area2D node
func _on_body_entered(body):
	if canHit:
		emit_signal("collisionDetected")


func _on_area_entered(area: Area2D) -> void:
	if canHit:
		$meteorDestructionSound.play()
		area.queue_free()
		$meteorSprite.hide()
		canHit = false
		await get_tree().create_timer(0.73).timeout
		queue_free()
		Global.score += 200
